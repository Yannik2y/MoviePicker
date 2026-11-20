//
//  MovieView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    var imageHeight: CGFloat = Layout.posterImageHeight
    
    var body: some View {
        VStack(spacing: 8) {
            TMDBPosterImage(movie: movie)
                .frame(height: imageHeight)
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
