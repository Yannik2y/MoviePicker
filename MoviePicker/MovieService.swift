//
//  MovieService.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation

/// Abstraction for movie catalog access (enables testing / DI)
@MainActor
protocol MovieCatalogServing: AnyObject {
    var moviesWithTMDBPosters: [Movie] { get }
    var bondMovies: [Movie] { get }
    var bondActors: [String] { get }
    var allActorsWithFilter: [String] { get }
    var fifaMovie: Movie? { get }
    func filterMovies(by actor: String) -> [Movie]
    func filterMovies(by actor: BondActor) -> [Movie]
    func hasMovies(for actor: String) -> Bool
    func hasMovies(for actor: BondActor) -> Bool
}

/// Service responsible for managing movie data and filtering logic
@MainActor
class MovieService: ObservableObject, MovieCatalogServing {
    static let shared = MovieService()
    
    @Published var moviesWithTMDBPosters: [Movie] = []
    @Published var isInitializingPosters = false
    
    private let posterCacheKey = "bondPosterURLCache"
    private let tmdbService: TMDBService
    private let maxConcurrentPosterFetches = 5
    
    init(tmdbService: TMDBService = .shared) {
        self.tmdbService = tmdbService
        moviesWithTMDBPosters = applyCachedPosterURLs(to: Movies)
        Task {
            await initializeTMDBPosters()
        }
    }
    
    var bondMovies: [Movie] {
        moviesWithTMDBPosters.filter { $0.title != MovieConstants.fifaWM2014Title }
    }
    
    var bondActors: [String] {
        BondActor.allCases.map(\.rawValue)
    }
    
    var bondActorsCases: [BondActor] {
        BondActor.allCases
    }
    
    var allActorsWithFilter: [String] {
        BondActor.allWithFilter
    }
    
    var fifaMovie: Movie? {
        moviesWithTMDBPosters.first { $0.title == MovieConstants.fifaWM2014Title }
    }
    
    /// Initialize TMDB poster URLs with cache + bounded parallelism
    private func initializeTMDBPosters() async {
        guard Config.hasValidAPIKey else {
            AppLogger.warning("Skipping TMDB poster init — API key not configured", category: .network)
            return
        }
        
        isInitializingPosters = true
        AppLogger.info("Starting TMDB poster initialization for \(Movies.count) movies", category: .network)
        
        var cache = loadPosterCache()
        var updatedMovies = moviesWithTMDBPosters
        var successCount = 0
        var failureCount = 0
        
        let needsFetch = Movies.filter { movie in
            movie.genre != "Sports" && cache[movie.cacheKey] == nil && movie.tmdbPosterURL == nil
        }
        
        await withTaskGroup(of: (String, URL?).self) { group in
            var iterator = needsFetch.makeIterator()
            var inFlight = 0
            
            func enqueueNext() {
                guard let movie = iterator.next() else { return }
                inFlight += 1
                group.addTask { [tmdbService] in
                    let url = await tmdbService.getBondMoviePosterURL(title: movie.title)
                    return (movie.cacheKey, url)
                }
            }
            
            for _ in 0..<min(maxConcurrentPosterFetches, needsFetch.count) {
                enqueueNext()
            }
            
            for await (key, url) in group {
                inFlight -= 1
                if let url {
                    cache[key] = url.absoluteString
                    successCount += 1
                } else {
                    failureCount += 1
                }
                enqueueNext()
            }
        }
        
        // Apply cache (including previously stored URLs) to catalog
        updatedMovies = applyCachedPosterURLs(to: Movies, cache: cache)
        moviesWithTMDBPosters = updatedMovies
        savePosterCache(cache)
        isInitializingPosters = false
        AppLogger.info("TMDB poster initialization complete: \(successCount) new, \(failureCount) failed this run", category: .network)
    }
    
    private func applyCachedPosterURLs(to movies: [Movie], cache: [String: String]? = nil) -> [Movie] {
        let cache = cache ?? loadPosterCache()
        return movies.map { movie in
            if movie.genre == "Sports" { return movie }
            if let cached = cache[movie.cacheKey], let url = URL(string: cached) {
                return movie.withPosterURL(url)
            }
            return movie
        }
    }
    
    private func loadPosterCache() -> [String: String] {
        UserDefaults.standard.dictionary(forKey: posterCacheKey) as? [String: String] ?? [:]
    }
    
    private func savePosterCache(_ cache: [String: String]) {
        UserDefaults.standard.set(cache, forKey: posterCacheKey)
    }
    
    func filterMovies(by actor: String) -> [Movie] {
        if actor == Strings.allActorsFilter {
            return bondMovies
        } else {
            return bondMovies.filter { $0.actor == actor }
        }
    }
    
    func filterMovies(by actor: BondActor) -> [Movie] {
        bondMovies.filter { $0.stars(actor) }
    }
    
    func hasMovies(for actor: String) -> Bool {
        !filterMovies(by: actor).isEmpty
    }
    
    func hasMovies(for actor: BondActor) -> Bool {
        !filterMovies(by: actor).isEmpty
    }
}

private extension Movie {
    var cacheKey: String { "\(title)|\(year)" }
    
    func withPosterURL(_ url: URL) -> Movie {
        Movie(
            id: id,
            title: title,
            year: year,
            actor: actor,
            genre: genre,
            imdbRating: imdbRating,
            poster: poster,
            tmdbPosterURL: url
        )
    }
}
