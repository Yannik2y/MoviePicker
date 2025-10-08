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
    @Binding var targetMovie: Movie? // Change to binding

    @State private var movieQueue: [Movie] = []
    @State private var isAnimating = false
    
    // The movies array already contains only Bond movies (filtered by caller)
    var scrollingMovies: [Movie] {
        movies
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(AppColors.posterBackground)
                .frame(width: Layout.adaptivePosterWidth, height: Layout.adaptivePosterHeight)
                .cornerRadius(Layout.posterCornerRadius)
                .offset(y: Layout.posterVerticalOffset)
            
            if let movie = randomMovie {
                // Check if this is a custom movie (not a Bond movie)
                if movie.genre == "Custom" {
                    CustomMovieView(movie: movie)
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: movie.id)
                } else {
                    MovieView(movie: movie)
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: movie.id)
                }
            }
        }
        .onChange(of: triggerScrolling) { oldValue, newValue in
            if newValue && !isAnimating {
                startScrollingAnimation()
            }
        }
        .onDisappear {
            // Clean up when view disappears
            movieQueue.removeAll()
            isAnimating = false
        }
    }

    private func startScrollingAnimation() {
        guard !scrollingMovies.isEmpty else {
            AppLogger.warning("Cannot start animation: no movies available", category: .ui)
            return 
        }
        
        AppLogger.debug("Starting scrolling animation with \(AnimationTiming.scrollAnimationCount) frames", category: .ui)
        
        // Clean up any existing animation
        movieQueue.removeAll()
        isAnimating = false
        
        // Create a queue of random Bond movies for the scrolling effect
        movieQueue = (0..<AnimationTiming.scrollAnimationCount).compactMap { _ in 
            scrollingMovies.randomElement() 
        }
        
        // If randomMovie is nil, start with the first movie in the queue
        if randomMovie == nil {
            randomMovie = movieQueue.first
            movieQueue.removeFirst()
        }
        
        // Start the animation sequence immediately
        displayNextMovie()
    }

    func displayNextMovie() {
        if let nextMovie = movieQueue.first {
            movieQueue.removeFirst()
            
            // Light haptic feedback for each scroll
            Task { @MainActor in
                HapticManager.shared.lightImpact()
            }
            
            withAnimation {
                isAnimating = true
                randomMovie = nextMovie
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTiming.scrollAnimationDelay) {
                if movieQueue.isEmpty {
                    // Add the target movie at the very end with animation
                    if let target = targetMovie {
                        AppLogger.info("Animation complete - landing on: '\(target.title)'", category: .ui)
                        
                        // Look up the latest version of this movie from the movies array
                        // This ensures we get the TMDB poster URL if it was loaded after initial selection
                        let finalMovie = movies.first { $0.title == target.title } ?? target
                        
                        // Success haptic for final selection
                        Task { @MainActor in
                            HapticManager.shared.success()
                            HapticManager.shared.heavyImpact()
                        }
                        
                        withAnimation {
                            randomMovie = finalMovie
                        }
                    } else {
                        AppLogger.error("Animation finished but no target movie was set!", category: .ui)
                    }
                    isAnimating = false
                    movieQueue.removeAll() // Clean up
                    triggerScrolling = false // Reset trigger after animation completes
                } else {
                    displayNextMovie()
                }
            }
        }
    }
}
