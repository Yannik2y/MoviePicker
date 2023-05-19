//
//  MenuView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @Binding var isShowingMenu: Bool
    @Binding var currentView: CurrentView

    var body: some View {
        VStack {
            Button(action: {
                currentView = .contentView
                isShowingMenu = false
            }) {
                Label("Bond Picker", systemImage: "film")
            }
            .padding()
            
            Button(action: {
                currentView = .dadModeView
                isShowingMenu = false
            }) {
                Label("Dad Mode", systemImage: "person.crop.circle.fill.badge.checkmark")
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut, value: isShowingMenu)
        .offset(y: isShowingMenu ? 0 : -300)
    }
}
