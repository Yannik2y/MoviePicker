//
//  Movie Poster.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 01.05.23.
//

import Foundation
import SwiftUI

struct MoviePoster: View {
    var movie: Movie

    var body: some View {
        VStack {
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}
