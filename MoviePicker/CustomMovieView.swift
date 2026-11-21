//
//  CustomMovieView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// View for displaying custom movies with poster images from disk / TMDB download
struct CustomMovieView: View {
    let movie: Movie
    var imageHeight: CGFloat = Layout.posterImageHeight
    @Environment(\.appDependencies) private var dependencies
    
    var body: some View {
        CustomMovieBody(
            movie: movie,
            imageHeight: imageHeight,
            storage: dependencies.customStorage
        )
    }
}

private struct CustomMovieBody: View {
    let movie: Movie
    var imageHeight: CGFloat
    @ObservedObject var storage: CustomMovieStorage
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if let posterImage = storage.posterImage {
                    Image(uiImage: posterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if movie.tmdbPosterURL != nil {
                    TMDBPosterImage(movie: movie, contentMode: .fill)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.12))
                        VStack(spacing: 8) {
                            Image(systemName: "film.fill")
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
            .frame(height: imageHeight)
            .frame(maxWidth: .infinity)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text("\(movie.actor) · \(movie.year)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(movie.title), \(movie.year), \(movie.actor)")
    }
}
