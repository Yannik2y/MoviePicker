//
//  TMDBPosterImage.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Cached TMDB poster with live URL resolve and branded local fallback
struct TMDBPosterImage: View {
    let movie: Movie
    var contentMode: ContentMode = .fill
    
    @Environment(\.appDependencies) private var dependencies
    @State private var loadedImage: UIImage?
    @State private var loadFailed = false
    
    private var resolvedURL: URL? {
        movie.tmdbPosterURL ?? dependencies.catalog.posterURL(for: movie)
    }
    
    var body: some View {
        Group {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if let localName = localAssetName {
                Image(localName)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder(showProgress: resolvedURL != nil && !loadFailed)
            }
        }
        .task(id: "\(movie.id)|\(resolvedURL?.absoluteString ?? "")") {
            await loadPoster()
        }
    }
    
    private var localAssetName: String? {
        UIImage(named: movie.poster) != nil ? movie.poster : nil
    }
    
    private func loadPoster() async {
        loadFailed = false
        guard let url = resolvedURL else {
            loadedImage = nil
            return
        }
        if let cached = dependencies.posterCache.image(for: url) {
            loadedImage = cached
            return
        }
        let image = await dependencies.posterCache.load(url)
        if Task.isCancelled { return }
        if let image {
            loadedImage = image
            loadFailed = false
        } else {
            loadFailed = true
        }
    }
    
    private func placeholder(showProgress: Bool) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.12))
            if showProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.5))
                    Text(movie.title)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
}
