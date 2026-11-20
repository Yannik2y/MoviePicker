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

    /// Split so any bulk replace of the placeholder cannot rewrite validation.
    private static let unsetAPIKey = "YOUR_API_" + "KEY_HERE"

    static var tmdbAPIKey: String {
        if let env = ProcessInfo.processInfo.environment["TMDB_API_KEY"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !env.isEmpty,
           env != unsetAPIKey {
            return env
        }
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String {
            let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, trimmed != unsetAPIKey {
                return trimmed
            }
        }
        return unsetAPIKey
    }

    static var hasValidAPIKey: Bool {
        let key = tmdbAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        return !key.isEmpty && key != unsetAPIKey && key.count >= 16
    }

    /// Key source label for diagnostics — never logs the key itself
    static var apiKeySource: String {
        if let env = ProcessInfo.processInfo.environment["TMDB_API_KEY"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !env.isEmpty,
           env != unsetAPIKey {
            return "environment"
        }
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: Any],
           let key = dict["TMDB_API_KEY"] as? String {
            let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, trimmed != unsetAPIKey {
                return "Secrets.plist"
            }
        }
        return hasValidAPIKey ? "compiled" : "stub"
    }

    static func logConfigurationOnce() {
        guard !didLogConfiguration else { return }
        didLogConfiguration = true
        AppLogger.info(
            "TMDB key configured=\(hasValidAPIKey) source=\(apiKeySource) length=\(tmdbAPIKey.count)",
            category: .network
        )
    }
}
