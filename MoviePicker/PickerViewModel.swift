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
    override func chooseTargetMovie() -> Movie? {
        guard let selectedMovie = filteredMovies.randomElement() else {
            errorMessage = Strings.ErrorMessages.unableToSelect
            HapticManager.shared.error()
            return nil
        }
        MovieHistory.shared.addToHistory(movie: selectedMovie, mode: .bondPicker)
        return selectedMovie
    }
}
