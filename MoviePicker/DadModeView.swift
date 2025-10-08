//
//  DadModeView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 07.05.23.
//

import SwiftUI

struct DadModeView: View {
    @ObservedObject var viewModel: DadModeViewModel

    var body: some View {
        SharedMoviePickerView(viewModel: viewModel)
    }
}


struct DadModeView_Previews: PreviewProvider {
    static var previews: some View {
        DadModeView(viewModel: DadModeViewModel())
    }
}
