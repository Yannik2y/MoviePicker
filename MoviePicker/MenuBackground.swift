//
//  MenuBackground.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import Foundation
import SwiftUI

struct MenuBackground: View {
    @Binding var isShowingMenu: Bool

    var body: some View {
        Color.black.opacity(isShowingMenu ? 0.8 : 0)
            .edgesIgnoringSafeArea(.all)
            .animation(.easeInOut, value: isShowingMenu)
    }
}
