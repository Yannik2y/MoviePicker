//
//  DadModeViewModel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 19.05.23.
//

import Foundation
import SwiftUI

class DadModeViewModel: ObservableObject {
    @Published var selectedActor: String = "All Actors"
    @Published var targetMovie: Movie? = nil
    @Published var randomMovie: Movie? = nil
    @Published var triggerScrolling: Bool = false
    @Published var filteredMovies: [Movie] = Movies.filter { $0.title != "FIFA WM 2014" }
    
    var allActors = Set(Movies.filter { $0.actor != "Die Deutsche 11" }.map { $0.actor }).union(["All Actors"]).sorted()
    let wm2014Movie = Movie(title: "FIFA WM 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014")
    
    init() {
        self.updateFilteredMovies()
    }
    
    func selectMovie() {
        if !triggerScrolling {
            targetMovie = Movies.first(where: { $0.title == "FIFA WM 2014" })
            triggerScrolling = true
        }
    }

    
    func updateFilteredMovies() {
        filteredMovies = selectedActor == "All Actors" ? Movies : Movies.filter { $0.actor == selectedActor }
    }
}

