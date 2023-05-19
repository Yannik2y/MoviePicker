//
//  ContentView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PickerViewModel()

    var body: some View {
        ContentViewBody(viewModel: viewModel)
    }
}

struct ContentViewBody: View {
    @ObservedObject var viewModel: PickerViewModel

    var body: some View {
        ZStack {
            Image("james-bond-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                PickerButton(action: {
                    viewModel.pickRandomMovie()
                })
                .padding(.top, 120)

                ActorPicker(selectedActor: $viewModel.selectedActor, allActors: viewModel.allActors)
                    .padding(.top, 130)

                Spacer()

                MovieScrollingView(
                    movies: Movies,
                    randomMovie: $viewModel.randomMovie,
                    triggerScrolling: $viewModel.triggerScrolling
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                Spacer()
            }
        }
        .onChange(of: viewModel.targetMovie) { newTargetMovie in
            viewModel.randomMovie = newTargetMovie
            viewModel.triggerScrolling.toggle()
        }
        .onChange(of: viewModel.selectedActor) { _ in
            viewModel.updateFilteredMovies()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Pass a constant value for previews
    }
}
