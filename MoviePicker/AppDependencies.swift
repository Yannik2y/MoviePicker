//
//  AppDependencies.swift
//  MoviePicker
//
//  Composition-root dependencies injected via Environment.
//

import SwiftUI

@MainActor
final class AppDependencies: ObservableObject {
    let catalog: MovieService
    let tmdb: TMDBService
    let history: MovieHistory
    let customStorage: CustomMovieStorage
    let posterCache: PosterImageCache
    let haptics: HapticManager
    
    init(
        catalog: MovieService? = nil,
        tmdb: TMDBService? = nil,
        history: MovieHistory? = nil,
        customStorage: CustomMovieStorage? = nil,
        posterCache: PosterImageCache? = nil,
        haptics: HapticManager? = nil
    ) {
        self.tmdb = tmdb ?? .shared
        self.catalog = catalog ?? .shared
        self.history = history ?? .shared
        self.customStorage = customStorage ?? .shared
        self.posterCache = posterCache ?? .shared
        self.haptics = haptics ?? .shared
    }
    
    /// Production graph — single shared instances
    static let live = AppDependencies()
}

private struct AppDependenciesKey: EnvironmentKey {
    @MainActor static let defaultValue = AppDependencies.live
}

extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
