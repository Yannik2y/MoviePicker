//
//  BondActor.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation

/// Represents actors who have played James Bond
/// 
/// Using an enum provides compile-time safety and prevents typos when
/// filtering movies by actor. The raw value matches the display name.
///
/// ## Usage
/// ```swift
/// let actor = BondActor.seanConnery
/// let movies = movieService.filterMovies(by: actor)
/// ```
enum BondActor: String, CaseIterable, Identifiable {
    case seanConnery = "Sean Connery"
    case georgeLazenby = "George Lazenby"
    case rogerMoore = "Roger Moore"
    case timothyDalton = "Timothy Dalton"
    case pierceBrosnan = "Pierce Brosnan"
    case danielCraig = "Daniel Craig"
    
    var id: String { rawValue }
    
    /// Display name for the actor
    var displayName: String {
        rawValue
    }
    
    /// All actors plus the "All Actors" filter option
    static var allWithFilter: [String] {
        [Strings.allActorsFilter] + allCases.map(\.rawValue)
    }
}

/// Special actor for non-Bond movies (e.g., WM-Halbfinale 2014)
struct SpecialActor {
    static let deutscheElf = "Die Deutsche 11"
}


