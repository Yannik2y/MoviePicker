//
//  MenuButton.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import Foundation
import SwiftUI

struct MenuButton: View {
    let action: () -> Void
    var isDadMode: Bool = false

    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .padding()

            Spacer()

            if isDadMode {
                Text("Dad Mode")  // Additional label
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
        }
        .background(Color.black.opacity(0.5))
    }
}
