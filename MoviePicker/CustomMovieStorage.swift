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
    /// Legacy field — migrated to disk; kept for decode compatibility
    let posterImageData: Data?
    /// Relative filename under Application Support when poster is on disk
    let posterFileName: String?
    
    init(
        title: String,
        year: Int,
        actor: String,
        tmdbId: Int?,
        posterImageData: Data? = nil,
        posterFileName: String? = nil
    ) {
        self.title = title
        self.year = year
        self.actor = actor
        self.tmdbId = tmdbId
        self.posterImageData = posterImageData
        self.posterFileName = posterFileName
    }
    
    func toMovie() -> Movie {
        Movie(
            id: tmdbId.map { "tmdb:\($0)" } ?? "custom:\(title)-\(year)",
            title: title,
            year: year,
            actor: actor,
            genre: "Custom",
            imdbRating: 0.0,
            poster: "custom_poster",
            tmdbPosterURL: nil
        )
    }
}

/// Manages storage and retrieval of custom movie selection
@MainActor
class CustomMovieStorage: ObservableObject {
    static let shared = CustomMovieStorage()
    
    private let customMovieKey = "customPickerMovie"
    private let posterFileName = "custom_poster.jpg"
    
    @Published var selectedMovie: CustomMovieData?
    @Published var posterImage: UIImage?
    
    private var postersDirectory: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let dir = appSupport.appendingPathComponent("MoviePicker", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
    
    private var posterFileURL: URL {
        postersDirectory.appendingPathComponent(posterFileName)
    }
    
    private init() {
        loadSelectedMovie()
    }
    
    /// Save custom movie selection
    func saveMovie(_ tmdbMovie: TMDBMovie, cast: [String], posterData: Data?) {
        var savedFileName: String? = nil
        if let posterData {
            do {
                try posterData.write(to: posterFileURL, options: .atomic)
                savedFileName = posterFileName
                posterImage = UIImage(data: posterData)
            } catch {
                AppLogger.error("Failed to write custom poster to disk", error: error, category: .storage)
            }
        }
        
        let movieData = CustomMovieData(
            title: tmdbMovie.title,
            year: tmdbMovie.year,
            actor: cast.isEmpty ? "Unknown" : cast.joined(separator: ", "),
            tmdbId: tmdbMovie.id,
            posterImageData: nil,
            posterFileName: savedFileName
        )
        
        do {
            let encoded = try JSONEncoder().encode(movieData)
            UserDefaults.standard.set(encoded, forKey: customMovieKey)
            selectedMovie = movieData
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
            selectedMovie = defaultMovie()
            return
        }
        
        do {
            var movieData = try JSONDecoder().decode(CustomMovieData.self, from: data)
            
            // Migrate legacy poster blob out of UserDefaults onto disk
            if let blob = movieData.posterImageData, !blob.isEmpty {
                do {
                    try blob.write(to: posterFileURL, options: .atomic)
                    movieData = CustomMovieData(
                        title: movieData.title,
                        year: movieData.year,
                        actor: movieData.actor,
                        tmdbId: movieData.tmdbId,
                        posterImageData: nil,
                        posterFileName: posterFileName
                    )
                    let encoded = try JSONEncoder().encode(movieData)
                    UserDefaults.standard.set(encoded, forKey: customMovieKey)
                    AppLogger.info("Migrated custom poster blob to disk", category: .storage)
                } catch {
                    AppLogger.error("Failed to migrate poster blob", error: error, category: .storage)
                }
            }
            
            selectedMovie = movieData
            if movieData.posterFileName != nil,
               let imageData = try? Data(contentsOf: posterFileURL) {
                posterImage = UIImage(data: imageData)
            }
            
            AppLogger.info("Loaded custom movie: '\(movieData.title)' (\(movieData.year))", category: .storage)
        } catch {
            AppLogger.error("Failed to decode saved movie data", error: error, category: .storage)
            selectedMovie = defaultMovie()
        }
    }
    
    func clearSelection() {
        UserDefaults.standard.removeObject(forKey: customMovieKey)
        try? FileManager.default.removeItem(at: posterFileURL)
        selectedMovie = nil
        posterImage = nil
    }
    
    var hasCustomMovie: Bool {
        selectedMovie != nil
    }
    
    private func defaultMovie() -> CustomMovieData {
        CustomMovieData(
            title: "The Notebook",
            year: 2004,
            actor: "Ryan Gosling, Rachel McAdams",
            tmdbId: nil,
            posterImageData: nil,
            posterFileName: nil
        )
    }
}
