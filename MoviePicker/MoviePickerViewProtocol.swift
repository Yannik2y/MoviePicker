//
//  MoviePickerViewProtocol.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Protocol that defines common behavior for movie picker view models
@MainActor
protocol MoviePickerViewModelProtocol: ObservableObject {
    var selectedActor: String { get set }
    var targetMovie: Movie? { get set }
    var randomMovie: Movie? { get set }
    var triggerScrolling: Bool { get set }
    var filteredMovies: [Movie] { get set }
    var errorMessage: String? { get set }
    var allMovies: [Movie] { get }
    var allActors: [String] { get }
    
    func selectMovie()
    func updateFilteredMovies()
}
