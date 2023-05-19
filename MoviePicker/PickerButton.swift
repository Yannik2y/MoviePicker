//
//  PickerButton.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import Foundation
import SwiftUI

struct PickerButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Bond Picker")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .background(Color.white)
                .cornerRadius(40)
                .foregroundColor(.black)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white, lineWidth: 5)
                )
        }
    }
}

