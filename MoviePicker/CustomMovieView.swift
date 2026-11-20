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
    @StateObject private var storage = CustomMovieStorage.shared
    
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
                                .foregroundColor(.white)
                            Text(movie.title)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            .clipped()
            
            VStack(spacing: 6) {
                Text(movie.title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                
                HStack(spacing: 10) {
                    Image(systemName: "person.fill")
                    Text(movie.actor)
                        .lineLimit(1)
                    Image(systemName: "calendar")
                    Text(verbatim: String(movie.year))
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 72)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(movie.title), \(movie.year), \(movie.actor)")
    }
}
