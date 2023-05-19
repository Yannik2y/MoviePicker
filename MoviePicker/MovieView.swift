//
//  MovieView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import Foundation
import SwiftUI

struct MovieView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            Text(movie.title)
                .font(.system(size: 23))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Text("Starring: \(movie.actor)")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Year: \(String(movie.year))")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0))
        .cornerRadius(10)
        .offset(y: -5)
    }
}
