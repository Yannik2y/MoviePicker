//
//  MovieScrollingView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 01.05.23.
//

import SwiftUI

struct MovieScrollingView: View {
    let movies: [Movie]
    @Binding var randomMovie: Movie?
    @Binding var triggerScrolling: Bool
    @Binding var targetMovie: Movie?
    var metrics: AdaptiveLayoutMetrics
    var reduceMotion: Bool = false
    
    @State private var animationTask: Task<Void, Never>?
    
    var body: some View {
        Group {
            if let movie = randomMovie {
                movieCard(for: movie)
                    .transition(.scale(scale: 0.92).combined(with: .opacity))
                    .animation(
                        reduceMotion ? .easeInOut(duration: 0.15) : .spring(response: 0.4, dampingFraction: 0.75),
                        value: movie.id
                    )
            } else {
                idlePrompt
            }
        }
        .frame(width: metrics.posterWidth, height: metrics.posterHeight)
        .onChange(of: triggerScrolling) { _, newValue in
            if newValue {
                startScrollingAnimation()
            }
        }
        .onDisappear {
            animationTask?.cancel()
            animationTask = nil
        }
    }
    
    @ViewBuilder
    private func movieCard(for movie: Movie) -> some View {
        Group {
            if movie.genre == "Custom" {
                CustomMovieView(movie: movie, imageHeight: metrics.posterImageHeight)
            } else {
                MovieView(movie: movie, imageHeight: metrics.posterImageHeight)
            }
        }
        .frame(width: metrics.posterWidth, height: metrics.posterHeight)
        .background(AppColors.posterBackground)
        .clipShape(RoundedRectangle(cornerRadius: Layout.posterCornerRadius, style: .continuous))
    }
    
    private var idlePrompt: some View {
        VStack(spacing: 14) {
            Image(systemName: "film.stack")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            Text(L10n.Empty.tapToPick)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.posterBackground.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: Layout.posterCornerRadius, style: .continuous))
    }
    
    private func startScrollingAnimation() {
        animationTask?.cancel()
        
        guard !movies.isEmpty else {
            AppLogger.warning("Cannot start animation: no movies available", category: .ui)
            triggerScrolling = false
            return
        }
        
        let steps = reduceMotion ? 1 : AnimationTiming.scrollAnimationCount
        let delay = reduceMotion ? 0.05 : AnimationTiming.scrollAnimationDelay
        
        AppLogger.debug("Starting scrolling animation with \(steps) frames", category: .ui)
        
        // Prefetch poster images for scroll candidates + target
        let prefetchURLs = movies.compactMap { $0.tmdbPosterURL ?? MovieService.shared.posterURL(for: $0) }
        PosterImageCache.shared.prefetch(Array(prefetchURLs.prefix(12)))
        if let target = targetMovie,
           let url = target.tmdbPosterURL ?? MovieService.shared.posterURL(for: target) {
            PosterImageCache.shared.prefetch([url])
        }
        
        animationTask = Task { @MainActor in
            var queue = (0..<steps).compactMap { _ in movies.randomElement() }
            
            // Seed immediately so we never show an empty glass box mid-pick
            if let first = queue.first {
                randomMovie = resolved(first)
                queue.removeFirst()
            }
            
            while !queue.isEmpty {
                if Task.isCancelled { return }
                let next = resolved(queue.removeFirst())
                HapticManager.shared.lightImpact()
                withAnimation {
                    randomMovie = next
                }
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            if Task.isCancelled { return }
            
            if let target = targetMovie {
                let finalMovie = resolved(
                    movies.first { $0.id == target.id || $0.title == target.title } ?? target
                )
                AppLogger.info("Animation complete - landing on: '\(finalMovie.title)'", category: .ui)
                HapticManager.shared.success()
                HapticManager.shared.heavyImpact()
                withAnimation {
                    randomMovie = finalMovie
                }
            } else {
                AppLogger.error("Animation finished but no target movie was set!", category: .ui)
            }
            
            triggerScrolling = false
        }
    }
    
    private func resolved(_ movie: Movie) -> Movie {
        MovieService.shared.resolvedMovie(matching: movie) ?? movie
    }
}
