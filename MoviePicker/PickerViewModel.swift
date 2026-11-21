//
//  PickerViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 19.05.23.
//

import Foundation
import SwiftUI

/// View model for the Bond Picker mode
@MainActor
final class PickerViewModel: BasePickerViewModel {
    private let history: MovieHistory
    
    init(movieService: MovieCatalogServing? = nil, history: MovieHistory? = nil) {
        self.history = history ?? .shared
        super.init(movieService: movieService)
    }
    
    override func chooseTargetMovie() -> Movie? {
        guard let selectedMovie = filteredMovies.randomElement() else {
            errorMessage = Strings.ErrorMessages.unableToSelect
            HapticManager.shared.error()
            return nil
        }
        history.addToHistory(movie: selectedMovie, mode: .bondPicker)
        return selectedMovie
    }
}
