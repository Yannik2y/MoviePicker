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
        movieService: MovieCatalogServing = MovieService.shared,
        storage: CustomMovieStorage = .shared
    ) {
        self.storage = storage
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
