//
//  TMDBPosterImage.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Simple AsyncImage wrapper for TMDB posters
/// Uses iOS built-in caching - no custom cache needed
struct TMDBPosterImage: View {
    let movie: Movie
    
    var body: some View {
        Group {
            if let posterURL = movie.tmdbPosterURL {
                // Use AsyncImage directly - it has built-in caching
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        // Loading state
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    case .success(let image):
                        // Image loaded successfully
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        // Failed to load
                        ZStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.5))
                                Text(movie.title)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // No TMDB poster URL - try local poster (e.g., WM-Halbfinale 2014)
                Image(movie.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
