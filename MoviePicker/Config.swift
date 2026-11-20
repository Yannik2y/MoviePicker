//
//  Config.swift
//  MoviePicker
//
//  Checked-in stub so clean clones compile. Never commit a real API key.
//  Local override (in order):
//  1. Scheme environment variable TMDB_API_KEY
//  2. Optional Secrets.plist in the app bundle (gitignored; see Secrets.plist.template)
//

import Foundation

enum Config {
    static var tmdbAPIKey: String {
        if let env = ProcessInfo.processInfo.environment["TMDB_API_KEY"], !env.isEmpty {
            return env
        }
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String,
           !key.isEmpty,
           key != "YOUR_API_KEY_HERE" {
            return key
        }
        return "YOUR_API_KEY_HERE"
    }

    static var hasValidAPIKey: Bool {
        let key = tmdbAPIKey
        return !key.isEmpty && key != "YOUR_API_KEY_HERE"
    }
}
