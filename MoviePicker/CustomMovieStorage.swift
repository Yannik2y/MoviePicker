//
//  CustomMovieStorage.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Custom movie data that can be saved and loaded
struct CustomMovieData: Codable {
    let title: String
    let year: Int
    let actor: String
    let tmdbId: Int?
    let posterImageData: Data?
    
    /// Convert to Movie struct for display
    func toMovie() -> Movie {
        Movie(
            title: title,
            year: year,
            actor: actor,
            genre: "Custom",
            imdbRating: 0.0,
            poster: "custom_poster", // Will be handled specially
            tmdbPosterURL: nil // Custom movies don't use TMDB posters
        )
    }
}

/// Manages storage and retrieval of custom movie selection
@MainActor
class CustomMovieStorage: ObservableObject {
    static let shared = CustomMovieStorage()
    
    private let customMovieKey = "customPickerMovie"
    private let customPosterKey = "customPosterImage"
    
    @Published var selectedMovie: CustomMovieData?
    @Published var posterImage: UIImage?
    
    private init() {
        loadSelectedMovie()
    }
    
    /// Save custom movie selection
    func saveMovie(_ tmdbMovie: TMDBMovie, cast: [String], posterData: Data?) {
        let movieData = CustomMovieData(
            title: tmdbMovie.title,
            year: tmdbMovie.year,
            actor: cast.isEmpty ? "Unknown" : cast.joined(separator: ", "),
            tmdbId: tmdbMovie.id,
            posterImageData: posterData
        )
        
        do {
            let encoded = try JSONEncoder().encode(movieData)
            UserDefaults.standard.set(encoded, forKey: customMovieKey)
            selectedMovie = movieData
            
            if let posterData = posterData {
                posterImage = UIImage(data: posterData)
            }
            
            AppLogger.info("Successfully saved custom movie: '\(movieData.title)' (\(movieData.year))", category: .storage)
            HapticManager.shared.success()
        } catch {
            AppLogger.error("Failed to save custom movie '\(movieData.title)'", error: error, category: .storage)
        }
    }
    
    /// Load saved movie
    func loadSelectedMovie() {
        guard let data = UserDefaults.standard.data(forKey: customMovieKey) else {
            AppLogger.info("No saved custom movie found, using default", category: .storage)
            // Set default movie if none selected
            selectedMovie = CustomMovieData(
                title: "The Notebook",
                year: 2004,
                actor: "Ryan Gosling, Rachel McAdams",
                tmdbId: nil,
                posterImageData: nil
            )
            return
        }
        
        do {
            let movieData = try JSONDecoder().decode(CustomMovieData.self, from: data)
            selectedMovie = movieData
            
            if let imageData = movieData.posterImageData {
                posterImage = UIImage(data: imageData)
            }
            
            AppLogger.info("Loaded custom movie: '\(movieData.title)' (\(movieData.year))", category: .storage)
        } catch {
            AppLogger.error("Failed to decode saved movie data", error: error, category: .storage)
            // Set default movie on decode error
            selectedMovie = CustomMovieData(
                title: "The Notebook",
                year: 2004,
                actor: "Ryan Gosling, Rachel McAdams",
                tmdbId: nil,
                posterImageData: nil
            )
        }
    }
    
    /// Clear custom movie selection
    func clearSelection() {
        UserDefaults.standard.removeObject(forKey: customMovieKey)
        selectedMovie = nil
        posterImage = nil
    }
    
    /// Check if a custom movie is configured
    var hasCustomMovie: Bool {
        selectedMovie != nil
    }
}

