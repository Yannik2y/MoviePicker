//
//  MovieHistory.swift
//  MoviePicker
//
//  Manages movie selection history and favorites
//

import Foundation
import SwiftUI

/// Represents a movie selection in history
struct MovieHistoryEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let movieTitle: String
    let movieYear: Int
    let actor: String
    let timestamp: Date
    let mode: PickerMode
    var isFavorite: Bool
    
    init(movie: Movie, mode: PickerMode, isFavorite: Bool = false) {
        self.id = UUID()
        self.movieTitle = movie.title
        self.movieYear = movie.year
        self.actor = movie.actor
        self.timestamp = Date()
        self.mode = mode
        self.isFavorite = isFavorite
    }
}

/// Picker mode for history tracking
enum PickerMode: String, Codable {
    case bondPicker = "Bond Picker"
    case customPicker = "Movie Picker"
    case dadMode = "Dad Mode"
}

/// Manages movie history and favorites
@MainActor
class MovieHistory: ObservableObject {
    static let shared = MovieHistory()
    
    @Published var entries: [MovieHistoryEntry] = []
    
    private let historyKey = "movieHistory"
    private let maxHistoryCount = 50
    
    private init() {
        loadHistory()
    }
    
    /// Add a movie to history
    func addToHistory(movie: Movie, mode: PickerMode) {
        // Check if this exact movie was just selected (prevent duplicates within 10 seconds)
        if let lastEntry = entries.first,
           lastEntry.movieTitle == movie.title,
           Date().timeIntervalSince(lastEntry.timestamp) < 10 {
            AppLogger.debug("Skipping duplicate history entry for '\(movie.title)'", category: .storage)
            return
        }
        
        let entry = MovieHistoryEntry(movie: movie, mode: mode)
        entries.insert(entry, at: 0)
        
        // Limit history size
        if entries.count > maxHistoryCount {
            entries = Array(entries.prefix(maxHistoryCount))
        }
        
        saveHistory()
        AppLogger.info("Added '\(movie.title)' to history (\(mode.rawValue))", category: .storage)
    }
    
    /// Toggle favorite status
    func toggleFavorite(id: UUID) {
        guard let index = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[index].isFavorite.toggle()
        saveHistory()
        
        let action = entries[index].isFavorite ? "Added to" : "Removed from"
        AppLogger.info("\(action) favorites: '\(entries[index].movieTitle)'", category: .storage)
        HapticManager.shared.lightImpact()
    }
    
    /// Get all favorites
    var favorites: [MovieHistoryEntry] {
        entries.filter { $0.isFavorite }
    }
    
    /// Clear all history
    func clearHistory() {
        entries.removeAll()
        saveHistory()
        AppLogger.info("History cleared", category: .storage)
    }
    
    /// Clear non-favorite history
    func clearNonFavorites() {
        entries = entries.filter { $0.isFavorite }
        saveHistory()
        AppLogger.info("Non-favorite history cleared", category: .storage)
    }
    
    // MARK: - Persistence
    
    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            AppLogger.error("Failed to save history", error: error, category: .storage)
        }
    }
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            AppLogger.debug("No history found", category: .storage)
            return
        }
        
        do {
            entries = try JSONDecoder().decode([MovieHistoryEntry].self, from: data)
            AppLogger.info("Loaded \(entries.count) history entries", category: .storage)
        } catch {
            AppLogger.error("Failed to load history", error: error, category: .storage)
        }
    }
    
    /// Get statistics
    var stats: HistoryStats {
        HistoryStats(
            totalSelections: entries.count,
            favoriteCount: favorites.count,
            mostSelectedActor: mostSelectedActor,
            mostUsedMode: mostUsedMode
        )
    }
    
    private var mostSelectedActor: String {
        let actorCounts = Dictionary(grouping: entries, by: { $0.actor })
            .mapValues { $0.count }
        return actorCounts.max(by: { $0.value < $1.value })?.key ?? "None"
    }
    
    private var mostUsedMode: PickerMode {
        let modeCounts = Dictionary(grouping: entries, by: { $0.mode })
            .mapValues { $0.count }
        return modeCounts.max(by: { $0.value < $1.value })?.key ?? .bondPicker
    }
}

/// History statistics
struct HistoryStats {
    let totalSelections: Int
    let favoriteCount: Int
    let mostSelectedActor: String
    let mostUsedMode: PickerMode
}

