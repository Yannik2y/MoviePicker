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
        VStack(spacing: 8) {
            Group {
                if let posterImage = storage.posterImage {
                    Image(uiImage: posterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageHeight)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.12))
                            .frame(height: imageHeight)
                        VStack {
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(spacing: 6) {
                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text(movie.actor)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text(verbatim: String(movie.year))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(movie.title), \(movie.year), \(movie.actor)")
    }
}
