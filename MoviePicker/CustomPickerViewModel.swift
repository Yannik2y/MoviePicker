//
//  CustomPickerViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Custom Picker ViewModel: Allows user to set any movie as the target
/// Perfect for "tricking" your movie-watching partner!
@MainActor
final class CustomPickerViewModel: ObservableObject {
    @Published var selectedActor: String = ""
    @Published var targetMovie: Movie? = nil
    @Published var randomMovie: Movie? = nil
    @Published var triggerScrolling: Bool = false
    @Published var filteredMovies: [Movie] = []
    @Published var errorMessage: String? = nil
    @Published var showingSettings: Bool = false
    
    @ObservedObject private var movieService = MovieService.shared
    private let storage = CustomMovieStorage.shared
    
    // Only include actual James Bond movies for filtering
    var allMovies: [Movie] {
        movieService.bondMovies
    }
    
    var allActors: [String] {
        movieService.allActorsWithFilter
    }
    
    /// The custom movie that will be the target
    var customMovie: Movie? {
        storage.selectedMovie?.toMovie()
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
        
        // Check if custom movie is set
        guard let customMovie = customMovie else {
            errorMessage = L10n.Error.noCustomMovie
            HapticManager.shared.warning()
            return
        }
        
        // Reset any previous state
        targetMovie = nil
        randomMovie = nil
        
        // Always target the custom movie
        targetMovie = customMovie
        triggerScrolling = true
        
        // Note: Custom Picker doesn't track to history (only Bond Picker does)
    }

    func updateFilteredMovies() {
        // Haptic feedback for filter change
        HapticManager.shared.selectionChanged()
        
        filteredMovies = movieService.filterMovies(by: selectedActor)
        
        if filteredMovies.isEmpty {
            errorMessage = Strings.ErrorMessages.noMoviesFound(for: selectedActor)
            HapticManager.shared.warning()
        } else {
            errorMessage = nil
        }
    }
    
    func openSettings() {
        showingSettings = true
    }
}

// Conform to protocol
extension CustomPickerViewModel: MoviePickerViewModelProtocol {}

