//
//  CustomPickerView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

struct CustomPickerView: View {
    @ObservedObject var viewModel: CustomPickerViewModel
    
    var body: some View {
        SharedMoviePickerView(viewModel: viewModel, buttonTitle: Strings.moviePickerTitle)
            .sheet(isPresented: $viewModel.showingSettings) {
                MovieSearchView(clearPickerCallback: {
                    viewModel.randomMovie = nil
                    viewModel.triggerScrolling = false
                })
                .presentationDetents([.large])
            }
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerView(viewModel: CustomPickerViewModel())
    }
}
