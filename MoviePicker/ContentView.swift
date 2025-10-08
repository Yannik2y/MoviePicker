//
//  ContentView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: PickerViewModel

    var body: some View {
        SharedMoviePickerView(viewModel: viewModel)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PickerViewModel())
    }
}
