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
        ZStack {
            Rectangle()
                .fill(AppColors.posterBackground)
                .frame(width: metrics.posterWidth, height: metrics.posterHeight)
                .cornerRadius(Layout.posterCornerRadius)
            
            if let movie = randomMovie {
                Group {
                    if movie.genre == "Custom" {
                        CustomMovieView(movie: movie, imageHeight: metrics.posterImageHeight)
                    } else {
                        MovieView(movie: movie, imageHeight: metrics.posterImageHeight)
                    }
                }
                .transition(.scale(scale: 0.8).combined(with: .opacity))
                .animation(
                    reduceMotion ? .easeInOut(duration: 0.15) : .spring(response: 0.4, dampingFraction: 0.75),
                    value: movie.id
                )
            }
        }
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
        
        animationTask = Task { @MainActor in
            var queue = (0..<steps).compactMap { _ in movies.randomElement() }
            
            if randomMovie == nil, let first = queue.first {
                randomMovie = first
                queue.removeFirst()
            }
            
            while !queue.isEmpty {
                if Task.isCancelled { return }
                let next = queue.removeFirst()
                HapticManager.shared.lightImpact()
                withAnimation {
                    randomMovie = next
                }
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            if Task.isCancelled { return }
            
            if let target = targetMovie {
                let finalMovie = movies.first { $0.id == target.id || $0.title == target.title } ?? target
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
}
