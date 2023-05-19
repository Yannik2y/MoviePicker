//
//  MovieScrollingView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 01.05.23.
//

import Foundation
import SwiftUI

struct MovieScrollingView: View {
    let movies: [Movie]
    @Binding var randomMovie: Movie?
    @Binding var triggerScrolling: Bool

    @State private var movieQueue: [Movie] = []
    @State private var isAnimating = false

    var scrollingMovies: [Movie] {
        movies.filter { $0.title != "FIFA WM 2014" }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 375, height: 330)
                .cornerRadius(10)
                .offset(y: -5)
            
            if let movie = randomMovie {
                MovieView(movie: movie)
                    .transition(.move(edge: .trailing))
                    .animation(.easeOut(duration: 0.3), value: movie)
            }
        }
        .onChange(of: triggerScrolling) { _ in
            // This is the modification here:
            if triggerScrolling && !isAnimating {
                movieQueue = Array(repeating: (), count: 6).map { _ in scrollingMovies.randomElement()! }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    movieQueue.append(randomMovie!)
                    displayNextMovie()
                }
            }
        }
        .onChange(of: randomMovie) { _ in
            if isAnimating {
                triggerScrolling = false // reset triggerScrolling
            }
        }
    }

    func displayNextMovie() {
        if let nextMovie = movieQueue.first {
            movieQueue.removeFirst()
            
            withAnimation {
                isAnimating = true
                randomMovie = nextMovie
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if movieQueue.isEmpty {
                    isAnimating = false
                } else {
                    displayNextMovie()
                }
            }
        }
    }
}
