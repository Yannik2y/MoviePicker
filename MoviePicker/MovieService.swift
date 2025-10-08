//
//  MovieService.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation

/// Service responsible for managing movie data and filtering logic
/// 
/// `MovieService` provides a centralized, thread-safe access point for all movie-related
/// data operations. It manages the collection of James Bond movies and provides
/// filtering capabilities based on actor selection.
///
/// ## Usage
/// ```swift
/// let service = MovieService.shared
/// let bondMovies = service.bondMovies
/// let filtered = service.filterMovies(by: "Sean Connery")
/// ```
///
/// - Note: This is a singleton to ensure consistent state across the app
@MainActor
class MovieService: ObservableObject {
    // MARK: - Singleton
    static let shared = MovieService()
    
    @Published var moviesWithTMDBPosters: [Movie] = []
    @Published var isInitializingPosters = false
    
    private init() {
        // Initialize with local posters first
        moviesWithTMDBPosters = Movies
        Task {
            await initializeTMDBPosters()
        }
    }
    
    // MARK: - Movie Access
    
    /// All James Bond movies (excludes special movies like WM-Halbfinale 2014)
    var bondMovies: [Movie] {
        moviesWithTMDBPosters.filter { $0.title != MovieConstants.fifaWM2014Title }
    }
    
    /// All unique actors who played James Bond (as strings for compatibility)
    var bondActors: [String] {
        BondActor.allCases.map(\.rawValue)
    }
    
    /// All Bond actors as enum cases
    var bondActorsCases: [BondActor] {
        BondActor.allCases
    }
    
    /// All actors including the "All Actors" option
    var allActorsWithFilter: [String] {
        BondActor.allWithFilter
    }
    
    /// The special WM-Halbfinale 2014 movie (used in Dad Mode)
    var fifaMovie: Movie {
        moviesWithTMDBPosters.first { $0.title == MovieConstants.fifaWM2014Title }!
    }
    
    // MARK: - TMDB Poster Initialization
    
    /// Initialize TMDB poster URLs for all Bond movies
    private func initializeTMDBPosters() async {
        isInitializingPosters = true
        AppLogger.info("Starting TMDB poster initialization for \(Movies.count) movies", category: .network)
        
        var updatedMovies: [Movie] = []
        var successCount = 0
        var failureCount = 0
        
        for movie in Movies {
            if movie.genre == "Sports" {
                // Keep WM-Halbfinale movie as-is
                updatedMovies.append(movie)
                AppLogger.debug("Skipping TMDB lookup for special movie: \(movie.title)", category: .network)
            } else {
                // Try to get TMDB poster URL for Bond movies
                if let tmdbURL = await TMDBService.shared.getBondMoviePosterURL(title: movie.title) {
                    let updatedMovie = Movie(
                        title: movie.title,
                        year: movie.year,
                        actor: movie.actor,
                        genre: movie.genre,
                        imdbRating: movie.imdbRating,
                        poster: movie.poster,
                        tmdbPosterURL: tmdbURL
                    )
                    updatedMovies.append(updatedMovie)
                    successCount += 1
                } else {
                    // Keep original movie if no TMDB poster found
                    updatedMovies.append(movie)
                    failureCount += 1
                }
            }
        }
        
        moviesWithTMDBPosters = updatedMovies
        isInitializingPosters = false
        AppLogger.info("TMDB poster initialization complete: \(successCount) successful, \(failureCount) failed", category: .network)
    }
    
    // MARK: - Filtering
    
    /// Filters Bond movies by actor (String-based for compatibility)
    /// - Parameter actor: The actor name, or "All Actors" to return all movies
    /// - Returns: Filtered array of movies
    func filterMovies(by actor: String) -> [Movie] {
        if actor == Strings.allActorsFilter {
            return bondMovies
        } else {
            return bondMovies.filter { $0.actor == actor }
        }
    }
    
    /// Filters Bond movies by actor (type-safe enum)
    /// - Parameter actor: The BondActor enum case
    /// - Returns: Filtered array of movies starring this actor
    func filterMovies(by actor: BondActor) -> [Movie] {
        bondMovies.filter { $0.stars(actor) }
    }
    
    /// Checks if filtering will result in any movies
    /// - Parameter actor: The actor name to check
    /// - Returns: True if there are movies for this actor
    func hasMovies(for actor: String) -> Bool {
        !filterMovies(by: actor).isEmpty
    }
    
    /// Checks if filtering will result in any movies (type-safe)
    /// - Parameter actor: The BondActor to check
    /// - Returns: True if there are movies for this actor
    func hasMovies(for actor: BondActor) -> Bool {
        !filterMovies(by: actor).isEmpty
    }
}


