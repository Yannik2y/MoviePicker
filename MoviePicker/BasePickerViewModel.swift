//
//  BasePickerViewModel.swift
//  MoviePicker
//

import Foundation
import SwiftUI

/// Shared picker state and filter/error handling for all modes
@MainActor
class BasePickerViewModel: ObservableObject {
    @Published var selectedActor: String = ""
    @Published var targetMovie: Movie? = nil
    @Published var randomMovie: Movie? = nil
    @Published var triggerScrolling: Bool = false
    @Published var filteredMovies: [Movie] = []
    @Published var errorMessage: String? = nil
    
    let movieService: MovieCatalogServing
    
    var allMovies: [Movie] {
        movieService.bondMovies
    }
    
    var allActors: [String] {
        movieService.allActorsWithFilter
    }
    
    init(movieService: MovieCatalogServing? = nil) {
        // Default args cannot reference @MainActor statics; resolve on the main actor here.
        self.movieService = movieService ?? MovieService.shared
        self.selectedActor = L10n.Filter.allActors
        self.updateFilteredMovies()
    }
    
    func selectMovie() {
        errorMessage = nil
        HapticManager.shared.mediumImpact()
        guard !triggerScrolling else { return }
        
        targetMovie = nil
        randomMovie = nil
        
        guard let chosen = chooseTargetMovie() else { return }
        targetMovie = chosen
        triggerScrolling = true
    }
    
    /// Subclasses override to decide the landing movie
    func chooseTargetMovie() -> Movie? {
        assertionFailure("Subclasses must override chooseTargetMovie()")
        return nil
    }
    
    func updateFilteredMovies() {
        HapticManager.shared.selectionChanged()
        filteredMovies = movieService.filterMovies(by: selectedActor)
        
        if filteredMovies.isEmpty {
            errorMessage = Strings.ErrorMessages.noMoviesFound(for: selectedActor)
            HapticManager.shared.warning()
        } else {
            errorMessage = nil
        }
    }
}

extension PickerViewModel: MoviePickerViewModelProtocol {}
extension DadModeViewModel: MoviePickerViewModelProtocol {}
extension CustomPickerViewModel: MoviePickerViewModelProtocol {}
