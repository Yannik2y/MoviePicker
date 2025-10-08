//
//  PickerViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 19.05.23.
//

import Foundation
import SwiftUI

/// View model for the Bond Picker mode
/// Handles movie selection and filtering logic
@MainActor
final class PickerViewModel: ObservableObject {
    @Published var selectedActor: String = ""
    @Published var targetMovie: Movie? = nil
    @Published var randomMovie: Movie? = nil
    @Published var triggerScrolling: Bool = false
    @Published var filteredMovies: [Movie] = []
    @Published var errorMessage: String? = nil
    
    @ObservedObject private var movieService = MovieService.shared

    // Only include actual James Bond movies
    var allMovies: [Movie] {
        movieService.bondMovies
    }
    
    var allActors: [String] {
        movieService.allActorsWithFilter
    }

    init() {
        // Use localized "All Actors" string
        self.selectedActor = L10n.Filter.allActors
        self.updateFilteredMovies()
    }

    func selectMovie() {
        // Clear any previous errors
        errorMessage = nil
        
        // Haptic feedback for button press
        HapticManager.shared.mediumImpact()
        
        // Prevent multiple rapid selections
        guard !triggerScrolling else { return }
        
        // Check if there are movies available
        guard !filteredMovies.isEmpty else {
            errorMessage = Strings.ErrorMessages.noMoviesForActor
            HapticManager.shared.warning()
            return
        }
        
        // Reset any previous state
        targetMovie = nil
        randomMovie = nil
        
        if let selectedMovie = filteredMovies.randomElement() {
            targetMovie = selectedMovie
            triggerScrolling = true
            
            // Add to history
            MovieHistory.shared.addToHistory(movie: selectedMovie, mode: .bondPicker)
        } else {
            errorMessage = Strings.ErrorMessages.unableToSelect
            HapticManager.shared.error()
        }
    }

    func updateFilteredMovies() {
        // Haptic feedback for filter change
        HapticManager.shared.selectionChanged()
        
        filteredMovies = movieService.filterMovies(by: selectedActor)
        
        // Ensure we have at least one movie
        if filteredMovies.isEmpty {
            errorMessage = Strings.ErrorMessages.noMoviesFound(for: selectedActor)
            HapticManager.shared.warning()
        } else {
            errorMessage = nil
        }
    }
}

