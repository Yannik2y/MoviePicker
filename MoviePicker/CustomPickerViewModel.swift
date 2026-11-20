//
//  CustomPickerViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Custom Picker: always lands on the user-configured movie
@MainActor
final class CustomPickerViewModel: BasePickerViewModel {
    @Published var showingSettings: Bool = false
    
    private let storage: CustomMovieStorage
    
    var customMovie: Movie? {
        storage.selectedMovie?.toMovie()
    }
    
    init(
        movieService: MovieCatalogServing? = nil,
        storage: CustomMovieStorage? = nil
    ) {
        // Default args cannot reference @MainActor statics; resolve on the main actor here.
        self.storage = storage ?? .shared
        super.init(movieService: movieService)
    }
    
    override func chooseTargetMovie() -> Movie? {
        guard let customMovie else {
            errorMessage = L10n.Error.noCustomMovie
            HapticManager.shared.warning()
            return nil
        }
        MovieHistory.shared.addToHistory(movie: customMovie, mode: .customPicker)
        return customMovie
    }
    
    func openSettings() {
        showingSettings = true
    }
}
