//
//  DadModeViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 19.05.23.
//

import Foundation
import SwiftUI

/// Dad Mode: always picks the 2014 World Cup Semifinal
@MainActor
final class DadModeViewModel: BasePickerViewModel {
    var wm2014Movie: Movie? {
        movieService.fifaMovie
    }
    
    override func chooseTargetMovie() -> Movie? {
        guard let movie = wm2014Movie else {
            errorMessage = Strings.ErrorMessages.unableToSelect
            HapticManager.shared.error()
            return nil
        }
        MovieHistory.shared.addToHistory(movie: movie, mode: .dadMode)
        return movie
    }
}
