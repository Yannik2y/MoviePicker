//
//  Config.swift
//  MoviePicker
//
//  Checked-in stub so clean clones compile. Never commit a real API key.
//  Local override (in order):
//  1. Scheme environment variable TMDB_API_KEY
//  2. Optional Secrets.plist in the app bundle (gitignored; see Secrets.plist.template)
//  Release CI injects the key into Config.swift.template before archive.
//

import Foundation

enum Config {
    private static var didLogConfiguration = false
    
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
    
    /// Key source label for diagnostics — never logs the key itself
    static var apiKeySource: String {
        if let env = ProcessInfo.processInfo.environment["TMDB_API_KEY"], !env.isEmpty {
            return "environment"
        }
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String,
           !key.isEmpty,
           key != "YOUR_API_KEY_HERE" {
            return "Secrets.plist"
        }
        // Compiled-in non-placeholder (CI injects into the template / Config.swift)
        if hasValidAPIKey {
            return "compiled"
        }
        return "stub"
    }
    
    static func logConfigurationOnce() {
        guard !didLogConfiguration else { return }
        didLogConfiguration = true
        AppLogger.info(
            "TMDB key configured=\(hasValidAPIKey) source=\(apiKeySource)",
            category: .network
        )
    }
}
