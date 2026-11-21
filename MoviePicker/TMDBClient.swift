//
//  TMDBClient.swift
//  MoviePicker
//
//  Actor-isolated TMDB networking boundary (testable via URLSession injection).
//

import Foundation

protocol TMDBClienting: Sendable {
    func searchMovies(query: String) async throws -> [TMDBMovie]
    func credits(movieId: Int) async throws -> [String]
    func posterURL(movieId: Int) async throws -> URL?
    func posterURL(forTitle title: String) async throws -> URL?
}

actor TMDBClient: TMDBClienting {
    private let baseURL = "https://api.themoviedb.org/3"
    private let session: URLSession
    private let apiKeyProvider: @Sendable () -> String
    private let hasValidKey: @Sendable () -> Bool
    
    init(
        session: URLSession? = nil,
        apiKeyProvider: @escaping @Sendable () -> String = { Config.tmdbAPIKey },
        hasValidKey: @escaping @Sendable () -> Bool = { Config.hasValidAPIKey }
    ) {
        if let session {
            self.session = session
        } else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 15
            config.timeoutIntervalForResource = 30
            config.waitsForConnectivity = true
            self.session = URLSession(configuration: config)
        }
        self.apiKeyProvider = apiKeyProvider
        self.hasValidKey = hasValidKey
    }
    
    private var preferredLanguageTag: String {
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        let region = Locale.current.region?.identifier ?? "US"
        return "\(language)-\(region)"
    }
    
    func searchMovies(query: String) async throws -> [TMDBMovie] {
        guard hasValidKey() else { throw TMDBError.noAPIKey }
        guard !query.isEmpty else { return [] }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let language = preferredLanguageTag
        let key = apiKeyProvider()
        let urlString = "\(baseURL)/search/movie?api_key=\(key)&query=\(encodedQuery)&language=\(language)"
        guard let url = URL(string: urlString) else { throw TMDBError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try Self.validate(response: response)
        return try JSONDecoder().decode(TMDBSearchResponse.self, from: data).results
    }
    
    func credits(movieId: Int) async throws -> [String] {
        guard hasValidKey() else { throw TMDBError.noAPIKey }
        let key = apiKeyProvider()
        let urlString = "\(baseURL)/movie/\(movieId)/credits?api_key=\(key)"
        guard let url = URL(string: urlString) else { throw TMDBError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try Self.validate(response: response)
        let credits = try JSONDecoder().decode(TMDBCredits.self, from: data)
        return credits.cast.prefix(3).map(\.name)
    }
    
    func posterURL(movieId: Int) async throws -> URL? {
        guard hasValidKey() else { throw TMDBError.noAPIKey }
        let key = apiKeyProvider()
        let language = preferredLanguageTag
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(key)&language=\(language)"
        guard let url = URL(string: urlString) else { throw TMDBError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try Self.validate(response: response)
        let movie = try JSONDecoder().decode(TMDBMovie.self, from: data)
        return movie.posterURL
    }
    
    func posterURL(forTitle title: String) async throws -> URL? {
        let movies = try await searchMovies(query: title)
        let exact = movies.first { $0.title.lowercased() == title.lowercased() }
        return (exact ?? movies.first)?.posterURL
    }
    
    private static func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDBError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200: return
        case 401: throw TMDBError.httpError(401)
        case 429: throw TMDBError.rateLimited
        default: throw TMDBError.httpError(httpResponse.statusCode)
        }
    }
}
