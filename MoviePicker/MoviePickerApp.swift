//
//  MoviePickerApp.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

struct MoviePickerApp: View {
    @StateObject var contentViewVM = PickerViewModel()
    @StateObject var dadModeViewVM = DadModeViewModel()

    @State private var currentView: CurrentView = .contentView
    @State private var isShowingMenu = false

    var body: some View {
        ZStack {
            switch currentView {
            case .contentView:
                ContentView(viewModel: contentViewVM)
            case .dadModeView:
                DadModeView(viewModel: dadModeViewVM)
            }
            
            VStack {
                Spacer().frame(height: 20)
                MenuButton(action: { isShowingMenu.toggle() }, isDadMode: currentView == .dadModeView)
                Spacer()
            }

            if isShowingMenu {
                MenuView(isShowingMenu: $isShowingMenu, currentView: $currentView)
            }
        }
    }
}

struct MoviePickerApp_Previews: PreviewProvider {
    static var previews: some View {
        MoviePickerApp()
    }
}
