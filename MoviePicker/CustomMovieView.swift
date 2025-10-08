//
//  CustomMovieView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// View for displaying custom movies with poster images from TMDB
struct CustomMovieView: View {
    let movie: Movie
    @StateObject private var storage = CustomMovieStorage.shared
    
    var body: some View {
        VStack(spacing: 8) {
            // Movie poster with subtle shadow
            Group {
                if let posterImage = storage.posterImage {
                    Image(uiImage: posterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Layout.posterImageHeight)
                } else {
                    // Fallback if no poster
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: Layout.posterFrameWidth - 100, height: Layout.posterImageHeight)
                        
                        VStack {
                            Image(systemName: "film.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text(movie.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
            }
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
                            .lineLimit(1)
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

