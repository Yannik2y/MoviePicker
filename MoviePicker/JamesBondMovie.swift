//
//  JamesBondMovie.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

struct Movie: Identifiable, Hashable {
    var id: String { title }
    let title: String
    let year: Int
    let actor: String
    let genre: String
    let imdbRating: Double
    let poster: String
}


let Movies = [
    Movie(title: "Dr. No", year: 1962, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.2, poster: "dr_no"),
    Movie(title: "From Russia with Love", year: 1963, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.4, poster: "from_russia_with_love"),
    Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.7, poster: "goldfinger"),
    Movie(title: "Thunderball", year: 1965, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 7.0, poster: "thunderball"),
    Movie(title: "You Only Live Twice", year: 1967, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.9, poster: "you_only_live_twice"),
    Movie(title: "On Her Majesty's Secret Service", year: 1969, actor: "George Lazenby", genre: "Action/Thriller", imdbRating: 6.7, poster: "on_her_majesty_secret_service"),
    Movie(title: "Diamonds Are Forever", year: 1971, actor: "Sean Connery", genre: "Action/Thriller", imdbRating: 6.6, poster: "diamonds_are_forever"),
    Movie(title: "Live and Let Die", year: 1973, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "live_and_let_die"),
    Movie(title: "The Man with the Golden Gun", year: 1974, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "the_man_with_the_golden_gun"),
    Movie(title: "The Spy Who Loved Me", year: 1977, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 7.1, poster: "the_spy_who_loved_me"),
    Movie(title: "Moonraker", year: 1979, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "moonraker"),
    Movie(title: "For Your Eyes Only", year: 1981, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.8, poster: "for_your_eyes_only"),
    Movie(title: "Octopussy", year: 1983, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.6, poster: "octopussy"),
    Movie(title: "A View to a Kill", year: 1985, actor: "Roger Moore", genre: "Action/Thriller", imdbRating: 6.3, poster: "a_view_to_a_kill"),
    Movie(title: "The Living Daylights", year: 1987, actor: "Timothy Dalton", genre: "Action/Adventure", imdbRating: 6.7, poster: "the_living_daylights"),
    Movie(title: "Licence to Kill", year: 1989, actor: "Timothy Dalton", genre: "Action/Thriller", imdbRating: 6.6, poster: "licence_to_kill"),
    Movie(title: "GoldenEye", year: 1995, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 7.2, poster: "goldeneye"),
    Movie(title: "Tomorrow Never Dies", year: 1997, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.5, poster: "tomorrow_never_dies"),
    Movie(title: "The World Is Not Enough", year: 1999, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.4, poster: "the_world_is_not_enough"),
    Movie(title: "Die Another Day", year: 2002, actor: "Pierce Brosnan", genre: "Action/Thriller", imdbRating: 6.1, poster: "die_another_day"),
    Movie(title: "Casino Royale", year: 2006, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 8.0, poster: "casino_royale"),
    Movie(title: "Quantum of Solace", year: 2008, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.6, poster: "quantum_of_solace"),
    Movie(title: "Skyfall", year: 2012, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.7, poster: "skyfall"),
    Movie(title: "Spectre", year: 2015, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 6.8, poster: "spectre"),
    Movie(title: "No Time to Die", year: 2021, actor: "Daniel Craig", genre: "Action/Thriller", imdbRating: 7.5, poster: "no_time_to_die"),
    Movie(title: "FIFA WM 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014")
    ]
