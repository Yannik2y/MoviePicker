//
//  JamesBondMovie.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Represents a movie in the picker app
/// Conforms to Equatable for optimized SwiftUI updates
struct Movie: Identifiable, Hashable, Equatable {
    var id: String { title }
    let title: String
    let year: Int
    let actor: String
    let genre: String
    let imdbRating: Double
    let poster: String
    let tmdbPosterURL: URL?
    
    /// Type-safe actor accessor
    var bondActor: BondActor? {
        BondActor(rawValue: actor)
    }
    
    /// Check if this movie stars a specific Bond actor
    func stars(_ bondActor: BondActor) -> Bool {
        actor == bondActor.rawValue
    }
    
    // Equatable conformance for performance optimization
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.title == rhs.title && lhs.year == rhs.year
    }
}

// Constants for special movies
struct MovieConstants {
    static let fifaWM2014Title = "WM-Halbfinale 2014"
}

let Movies = [
    Movie(title: "Dr. No", year: 1962, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.2, poster: "dr_no", tmdbPosterURL: nil),
    Movie(title: "From Russia with Love", year: 1963, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.4, poster: "from_russia_with_love", tmdbPosterURL: nil),
    Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.7, poster: "goldfinger", tmdbPosterURL: nil),
    Movie(title: "Thunderball", year: 1965, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.0, poster: "thunderball", tmdbPosterURL: nil),
    Movie(title: "You Only Live Twice", year: 1967, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.9, poster: "you_only_live_twice", tmdbPosterURL: nil),
    Movie(title: "On Her Majesty's Secret Service", year: 1969, actor: "George Lazenby", genre: "Action/Thriller", imdbRating: 6.7, poster: "on_her_majesty_secret_service", tmdbPosterURL: nil),
    Movie(title: "Diamonds Are Forever", year: 1971, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.6, poster: "diamonds_are_forever", tmdbPosterURL: nil),
    Movie(title: "Live and Let Die", year: 1973, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "live_and_let_die", tmdbPosterURL: nil),
    Movie(title: "The Man with the Golden Gun", year: 1974, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "the_man_with_the_golden_gun", tmdbPosterURL: nil),
    Movie(title: "The Spy Who Loved Me", year: 1977, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 7.1, poster: "the_spy_who_loved_me", tmdbPosterURL: nil),
    Movie(title: "Moonraker", year: 1979, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "moonraker", tmdbPosterURL: nil),
    Movie(title: "For Your Eyes Only", year: 1981, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "for_your_eyes_only", tmdbPosterURL: nil),
    Movie(title: "Octopussy", year: 1983, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.6, poster: "octopussy", tmdbPosterURL: nil),
    Movie(title: "A View to a Kill", year: 1985, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "a_view_to_a_kill", tmdbPosterURL: nil),
    Movie(title: "The Living Daylights", year: 1987, actor: "Timothy Dalton", genre: "Action/Adventure", imdbRating: 6.7, poster: "the_living_daylights", tmdbPosterURL: nil),
    Movie(title: "Licence to Kill", year: 1989, actor: "Timothy Dalton", genre: "Action/Thriller", imdbRating: 6.6, poster: "licence_to_kill", tmdbPosterURL: nil),
    Movie(title: "GoldenEye", year: 1995, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 7.2, poster: "goldeneye", tmdbPosterURL: nil),
    Movie(title: "Tomorrow Never Dies", year: 1997, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.5, poster: "tomorrow_never_dies", tmdbPosterURL: nil),
    Movie(title: "The World Is Not Enough", year: 1999, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.4, poster: "the_world_is_not_enough", tmdbPosterURL: nil),
    Movie(title: "Die Another Day", year: 2002, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.1, poster: "die_another_day", tmdbPosterURL: nil),
    Movie(title: "Casino Royale", year: 2006, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 8.0, poster: "casino_royale", tmdbPosterURL: nil),
    Movie(title: "Quantum of Solace", year: 2008, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.6, poster: "quantum_of_solace", tmdbPosterURL: nil),
    Movie(title: "Skyfall", year: 2012, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.7, poster: "skyfall", tmdbPosterURL: nil),
    Movie(title: "Spectre", year: 2015, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.8, poster: "spectre", tmdbPosterURL: nil),
    Movie(title: "No Time to Die", year: 2021, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.5, poster: "no_time_to_die", tmdbPosterURL: nil),
    Movie(title: "WM-Halbfinale 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014", tmdbPosterURL: nil)
    ]
