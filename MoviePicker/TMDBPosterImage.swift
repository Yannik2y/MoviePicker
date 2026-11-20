//
//  TMDBPosterImage.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// AsyncImage wrapper for TMDB posters with branded local fallback
struct TMDBPosterImage: View {
    let movie: Movie
    
    var body: some View {
        Group {
            if let posterURL = movie.tmdbPosterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        placeholder(showProgress: true)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        localOrBrandedFallback
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                localOrBrandedFallback
            }
        }
    }
    
    @ViewBuilder
    private var localOrBrandedFallback: some View {
        if UIImage(named: movie.poster) != nil {
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            placeholder(showProgress: false)
        }
    }
    
    private func placeholder(showProgress: Bool) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.1))
            if showProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "film")
                        .font(.system(size: 40))
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
