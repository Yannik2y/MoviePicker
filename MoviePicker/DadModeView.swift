//
//  DadModeView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 07.05.23.
//

import Foundation
import SwiftUI

struct DadModeView: View {
    @StateObject var viewModel = DadModeViewModel()

    var body: some View {
        DadModeViewBody(viewModel: viewModel)
    }
}

struct DadModeViewBody: View {
    @ObservedObject var viewModel: DadModeViewModel

    var body: some View {
        ZStack {
            Image("james-bond-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack {
                PickerButton(action: {
                    viewModel.selectMovie()
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


struct DadModeView_Previews: PreviewProvider {
    static var previews: some View {
        DadModeView() // Pass a constant value for previews
    }
}
