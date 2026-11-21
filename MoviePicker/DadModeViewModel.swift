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
    private let history: MovieHistory
    
    init(movieService: MovieCatalogServing? = nil, history: MovieHistory? = nil) {
        self.history = history ?? .shared
        super.init(movieService: movieService)
    }
    
    var wm2014Movie: Movie? {
        movieService.fifaMovie
    }
    
    override func chooseTargetMovie() -> Movie? {
        guard let movie = wm2014Movie else {
            errorMessage = Strings.ErrorMessages.unableToSelect
            HapticManager.shared.error()
            return nil
        }
        history.addToHistory(movie: movie, mode: .dadMode)
        return movie
    }
}
