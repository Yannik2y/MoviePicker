//
//  MoviePickerViewProtocol.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Protocol that defines common behavior for movie picker view models
///
/// This protocol enables code reuse between different picker modes (e.g., regular and Dad Mode)
/// by defining a common interface that both view models must implement. This allows the
/// `SharedMoviePickerView` to work with any conforming view model through protocol-oriented
/// programming.
///
/// ## Conforming Types
/// - `PickerViewModel`: Standard random movie selection
/// - `DadModeViewModel`: Always selects WM-Halbfinale 2014
///
/// - Important: All properties and methods must be accessible from the main actor
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

// Make PickerViewModel conform to the protocol
extension PickerViewModel: MoviePickerViewModelProtocol {}

// DadModeViewModel already has selectMovie(), so it conforms naturally
extension DadModeViewModel: MoviePickerViewModelProtocol {}


