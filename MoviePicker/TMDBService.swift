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
    
    // API key is now stored in Config.swift (excluded from Git)
    // See Config.swift.template for setup instructions
    private let apiKey = Config.tmdbAPIKey
    private let baseURL = "https://api.themoviedb.org/3"
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    /// Search for movies by title
    func searchMovies(query: String) async throws -> [TMDBMovie] {
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" else {
            throw TMDBError.noAPIKey
        }
        
        guard !query.isEmpty else {
            return []
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=en-US"
        
        guard let url = URL(string: urlString) else {
            throw TMDBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw TMDBError.httpError(httpResponse.statusCode)
        }
        
        let searchResponse = try JSONDecoder().decode(TMDBSearchResponse.self, from: data)
        return searchResponse.results
    }
    
    /// Get movie credits (cast)
    func getMovieCredits(movieId: Int) async throws -> [String] {
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" else {
            throw TMDBError.noAPIKey
        }
        
        let urlString = "\(baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw TMDBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TMDBError.invalidResponse
        }
        
        let credits = try JSONDecoder().decode(TMDBCredits.self, from: data)
        return credits.cast.prefix(3).map { $0.name }
    }
    
    /// Get poster URL for a Bond movie by title
    func getBondMoviePosterURL(title: String) async -> URL? {
        do {
            // Search for the movie
            let movies = try await searchMovies(query: title)
            
            // Find the best match (exact title match preferred)
            let exactMatch = movies.first { $0.title.lowercased() == title.lowercased() }
            let bestMatch = exactMatch ?? movies.first
            
            if let posterURL = bestMatch?.posterURL {
                AppLogger.info("Found poster for '\(title)': \(posterURL.absoluteString)", category: .network)
                return posterURL
            } else {
                AppLogger.warning("No poster found for '\(title)'", category: .network)
                return nil
            }
        } catch {
            AppLogger.error("Error fetching poster for '\(title)'", error: error, category: .network)
            return nil
        }
    }
}

/// TMDB API Errors
enum TMDBError: LocalizedError {
    case noAPIKey
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "TMDB API key not configured. Please add your API key to TMDBService.swift"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}

