//
//  CustomPickerView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

struct CustomPickerView: View {
    @ObservedObject var viewModel: CustomPickerViewModel
    @State private var showSettingsGear = false
    
    var body: some View {
        SharedMoviePickerView(viewModel: viewModel, buttonTitle: Strings.moviePickerTitle)
        .sheet(isPresented: $viewModel.showingSettings) {
            MovieSearchView(clearPickerCallback: {
                // Clear the picker display when a new movie is selected
                viewModel.randomMovie = nil
                viewModel.triggerScrolling = false
            })
        }
        .onChange(of: viewModel.showingSettings) { oldValue, newValue in
            // Hide the settings gear when sheet is dismissed
            if oldValue && !newValue {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    showSettingsGear = false
                }
            }
        }
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerView(viewModel: CustomPickerViewModel())
    }
}

