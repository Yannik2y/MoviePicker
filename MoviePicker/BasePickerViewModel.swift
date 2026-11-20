//
//  BasePickerViewModel.swift
//  MoviePicker
//

import Combine
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
    @Published var isPreparingPosters: Bool = false
    
    let movieService: MovieCatalogServing
    
    private var hydrateCancellable: AnyCancellable?
    
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
        self.updateFilteredMovies(haptic: false)
        observeCatalogHydration()
    }
    
    func selectMovie() {
        errorMessage = nil
        HapticManager.shared.mediumImpact()
        guard !triggerScrolling else { return }
        
        if let service = movieService as? MovieService,
           service.isInitializingPosters,
           service.bondMovies.allSatisfy({ $0.tmdbPosterURL == nil }) {
            // Cold start with empty URL cache — wait a beat rather than pick blank cards
            isPreparingPosters = true
        }
        
        // Keep last poster visible; do not clear to an empty frosted box
        targetMovie = nil
        
        guard let chosen = chooseTargetMovie() else {
            isPreparingPosters = false
            return
        }
        
        let resolved = movieService.resolvedMovie(matching: chosen) ?? chosen
        targetMovie = resolved
        
        // Seed first scroll frame immediately if nothing is showing yet
        if randomMovie == nil {
            randomMovie = allMovies.randomElement().map { movieService.resolvedMovie(matching: $0) ?? $0 } ?? resolved
        }
        
        isPreparingPosters = false
        triggerScrolling = true
    }
    
    /// Subclasses override to decide the landing movie
    func chooseTargetMovie() -> Movie? {
        assertionFailure("Subclasses must override chooseTargetMovie()")
        return nil
    }
    
    func updateFilteredMovies(haptic: Bool = true) {
        if haptic {
            HapticManager.shared.selectionChanged()
        }
        filteredMovies = movieService.filterMovies(by: selectedActor)
        
        if filteredMovies.isEmpty {
            errorMessage = Strings.ErrorMessages.noMoviesFound(for: selectedActor)
            if haptic {
                HapticManager.shared.warning()
            }
        } else {
            errorMessage = nil
        }
    }
    
    /// Re-apply catalog URLs onto live picker state after TMDB hydration
    func refreshMoviesFromCatalog() {
        updateFilteredMovies(haptic: false)
        
        if let random = randomMovie {
            randomMovie = movieService.resolvedMovie(matching: random) ?? random
        }
        if let target = targetMovie {
            targetMovie = movieService.resolvedMovie(matching: target) ?? target
        }
        
        if let service = movieService as? MovieService {
            isPreparingPosters = service.isInitializingPosters
        }
    }
    
    private func observeCatalogHydration() {
        guard let service = movieService as? MovieService else { return }
        
        isPreparingPosters = service.isInitializingPosters
        
        hydrateCancellable = Publishers.CombineLatest(
            service.$moviesWithTMDBPosters,
            service.$isInitializingPosters
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] _, initializing in
            guard let self else { return }
            self.isPreparingPosters = initializing
            self.refreshMoviesFromCatalog()
        }
    }
}

extension PickerViewModel: MoviePickerViewModelProtocol {}
extension DadModeViewModel: MoviePickerViewModelProtocol {}
extension CustomPickerViewModel: MoviePickerViewModelProtocol {}
