//
//  PickerViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 19.05.23.
//

import Foundation
import SwiftUI

class PickerViewModel: ObservableObject {
    @Published var selectedActor: String = "All Actors"
    @Published var targetMovie: Movie? = nil
    @Published var randomMovie: Movie? = nil
    @Published var triggerScrolling: Bool = false
    @Published var filteredMovies: [Movie] = Movies

    var allMovies = Movies.filter { $0.title != "FIFA WM 2014" }
    var allActors = Set(Movies.filter { $0.title != "FIFA WM 2014" }.map { $0.actor }).union(["All Actors"]).sorted()

    init() {
        self.updateFilteredMovies()
    }

    func pickRandomMovie() {
        if !triggerScrolling {
            targetMovie = filteredMovies.randomElement()
            triggerScrolling = true
        }
    }

    func updateFilteredMovies() {
        filteredMovies = selectedActor == "All Actors" ? Movies : Movies.filter { $0.actor == selectedActor }
    }
}

