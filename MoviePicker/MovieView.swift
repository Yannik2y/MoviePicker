//
//  MovieView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import SwiftUI

struct MovieView: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 8) {
            // Movie poster with subtle shadow
            TMDBPosterImage(movie: movie)
                .frame(height: Layout.posterImageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Movie info
            VStack(spacing: 6) {
                Text(movie.title)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        Text(movie.actor)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        Text(verbatim: String(movie.year))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0))
        .cornerRadius(Layout.posterCornerRadius)
        .offset(y: Layout.posterVerticalOffset)
    }
}
