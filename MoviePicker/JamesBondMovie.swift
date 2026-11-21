//
//  JamesBondMovie.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Represents a movie in the picker app
struct Movie: Identifiable, Hashable, Equatable {
    let id: String
    let title: String
    let year: Int
    let actor: String
    let genre: String
    let imdbRating: Double
    let poster: String
    let tmdbPosterURL: URL?
    /// Stable TMDB movie id when known (Bond catalog); nil for local-only entries
    let tmdbId: Int?
    
    init(
        id: String? = nil,
        title: String,
        year: Int,
        actor: String,
        genre: String,
        imdbRating: Double,
        poster: String,
        tmdbPosterURL: URL? = nil,
        tmdbId: Int? = nil
    ) {
        self.id = id ?? "\(title)-\(year)"
        self.title = title
        self.year = year
        self.actor = actor
        self.genre = genre
        self.imdbRating = imdbRating
        self.poster = poster
        self.tmdbPosterURL = tmdbPosterURL
        self.tmdbId = tmdbId
    }
    
    /// Type-safe actor accessor
    var bondActor: BondActor? {
        BondActor(rawValue: actor)
    }
    
    /// Check if this movie stars a specific Bond actor
    func stars(_ bondActor: BondActor) -> Bool {
        actor == bondActor.rawValue
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func withPosterURL(_ url: URL?) -> Movie {
        Movie(
            id: id,
            title: title,
            year: year,
            actor: actor,
            genre: genre,
            imdbRating: imdbRating,
            poster: poster,
            tmdbPosterURL: url,
            tmdbId: tmdbId
        )
    }
}

// Constants for special movies
struct MovieConstants {
    static let fifaWM2014Title = "WM-Halbfinale 2014"
}

/// Official Bond catalog with stable TMDB ids for poster resolution
let Movies: [Movie] = [
    Movie(title: "Dr. No", year: 1962, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.2, poster: "dr_no", tmdbId: 646),
    Movie(title: "From Russia with Love", year: 1963, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.4, poster: "from_russia_with_love", tmdbId: 657),
    Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.7, poster: "goldfinger", tmdbId: 658),
    Movie(title: "Thunderball", year: 1965, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.0, poster: "thunderball", tmdbId: 660),
    Movie(title: "You Only Live Twice", year: 1967, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.9, poster: "you_only_live_twice", tmdbId: 667),
    Movie(title: "On Her Majesty's Secret Service", year: 1969, actor: "George Lazenby", genre: "Action/Thriller", imdbRating: 6.7, poster: "on_her_majesty_secret_service", tmdbId: 668),
    Movie(title: "Diamonds Are Forever", year: 1971, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.6, poster: "diamonds_are_forever", tmdbId: 681),
    Movie(title: "Live and Let Die", year: 1973, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "live_and_let_die", tmdbId: 253),
    Movie(title: "The Man with the Golden Gun", year: 1974, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "the_man_with_the_golden_gun", tmdbId: 682),
    Movie(title: "The Spy Who Loved Me", year: 1977, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 7.1, poster: "the_spy_who_loved_me", tmdbId: 691),
    Movie(title: "Moonraker", year: 1979, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "moonraker", tmdbId: 698),
    Movie(title: "For Your Eyes Only", year: 1981, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "for_your_eyes_only", tmdbId: 699),
    Movie(title: "Octopussy", year: 1983, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.6, poster: "octopussy", tmdbId: 707),
    Movie(title: "A View to a Kill", year: 1985, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "a_view_to_a_kill", tmdbId: 708),
    Movie(title: "The Living Daylights", year: 1987, actor: "Timothy Dalton", genre: "Action/Adventure", imdbRating: 6.7, poster: "the_living_daylights", tmdbId: 709),
    Movie(title: "Licence to Kill", year: 1989, actor: "Timothy Dalton", genre: "Action/Thriller", imdbRating: 6.6, poster: "licence_to_kill", tmdbId: 873),
    Movie(title: "GoldenEye", year: 1995, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 7.2, poster: "goldeneye", tmdbId: 710),
    Movie(title: "Tomorrow Never Dies", year: 1997, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.5, poster: "tomorrow_never_dies", tmdbId: 714),
    Movie(title: "The World Is Not Enough", year: 1999, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.4, poster: "the_world_is_not_enough", tmdbId: 36643),
    Movie(title: "Die Another Day", year: 2002, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.1, poster: "die_another_day", tmdbId: 36670),
    Movie(title: "Casino Royale", year: 2006, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 8.0, poster: "casino_royale", tmdbId: 36557),
    Movie(title: "Quantum of Solace", year: 2008, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.6, poster: "quantum_of_solace", tmdbId: 10764),
    Movie(title: "Skyfall", year: 2012, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.7, poster: "skyfall", tmdbId: 37724),
    Movie(title: "Spectre", year: 2015, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.8, poster: "spectre", tmdbId: 206647),
    Movie(title: "No Time to Die", year: 2021, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.5, poster: "no_time_to_die", tmdbId: 370172),
    Movie(title: "WM-Halbfinale 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014", tmdbId: nil)
]
