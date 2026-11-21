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
        VStack(spacing: 0) {
            TMDBPosterImage(movie: movie, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: imageHeight)
                .clipped()
            
            metaBand
                .frame(maxWidth: .infinity)
                .frame(minHeight: 72)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(movie.title), \(movie.year), \(movie.actor)")
    }
    
    private var metaBand: some View {
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
    }
}
