//
//  TMDBService.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation

/// TMDB API Movie Response Model
struct TMDBMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let release_date: String?
    let poster_path: String?
    let overview: String?
    let vote_average: Double?
    
    var year: Int {
        guard let dateString = release_date,
              let year = Int(dateString.prefix(4)) else {
            return 0
        }
        return year
    }
    
    var posterURL: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

struct TMDBSearchResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBCredits: Codable {
    let cast: [TMDBCast]
}

struct TMDBCast: Codable {
    let name: String
    let order: Int
}

/// Service for interacting with The Movie Database (TMDB) API
@MainActor
class TMDBService: ObservableObject {
    static let shared = TMDBService()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let session: URLSession
    
    /// Always read live from Config so CI inject / Secrets.plist cannot go stale at init.
    private var apiKey: String { Config.tmdbAPIKey }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var preferredLanguageTag: String {
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        let region = Locale.current.region?.identifier ?? "US"
        return "\(language)-\(region)"
    }
    
    /// Actor-backed client for ID-based poster lookups
    private let client: TMDBClient
    
    init(session: URLSession? = nil, client: TMDBClient? = nil) {
        let resolvedSession: URLSession
        if let session {
            resolvedSession = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 15
            config.timeoutIntervalForResource = 30
            config.waitsForConnectivity = true
            resolvedSession = URLSession(configuration: config)
        }
        self.session = resolvedSession
        self.client = client ?? TMDBClient(session: resolvedSession)
    }
    
    /// Search for movies by title
    func searchMovies(query: String) async throws -> [TMDBMovie] {
        guard Config.hasValidAPIKey else {
            throw TMDBError.noAPIKey
        }
        
        guard !query.isEmpty else {
            return []
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let language = preferredLanguageTag
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=\(language)"
        
        guard let url = URL(string: urlString) else {
            throw TMDBError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        
        let searchResponse = try JSONDecoder().decode(TMDBSearchResponse.self, from: data)
        return searchResponse.results
    }
    
    /// Get movie credits (cast)
    func getMovieCredits(movieId: Int) async throws -> [String] {
        guard Config.hasValidAPIKey else {
            throw TMDBError.noAPIKey
        }
        
        let urlString = "\(baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw TMDBError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validate(response: response)
        
        let credits = try JSONDecoder().decode(TMDBCredits.self, from: data)
        return credits.cast.prefix(3).map { $0.name }
    }
    
    /// Get poster URL by stable TMDB id (preferred) or title search fallback
    func getBondMoviePosterURL(title: String, tmdbId: Int? = nil) async -> URL? {
        do {
            if let tmdbId {
                if let url = try await client.posterURL(movieId: tmdbId) {
                    AppLogger.info("Found poster for id \(tmdbId) ('\(title)'): \(url.absoluteString)", category: .network)
                    return url
                }
            }
            if let url = try await client.posterURL(forTitle: title) {
                AppLogger.info("Found poster for '\(title)' via search: \(url.absoluteString)", category: .network)
                return url
            }
            AppLogger.warning("No poster found for '\(title)'", category: .network)
            return nil
        } catch {
            AppLogger.error("Error fetching poster for '\(title)'", error: error, category: .network)
            return nil
        }
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200:
            return
        case 401:
            throw TMDBError.httpError(401)
        case 429:
            throw TMDBError.rateLimited
        default:
            throw TMDBError.httpError(httpResponse.statusCode)
        }
    }
}

/// TMDB API Errors
enum TMDBError: LocalizedError {
    case noAPIKey
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case rateLimited
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "TMDB API key not configured. Set TMDB_API_KEY in the Xcode scheme or add Secrets.plist (see Secrets.plist.template)."
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .rateLimited:
            return "TMDB rate limit exceeded. Please try again shortly."
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
