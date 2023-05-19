//
//  ActorPickerLabel.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import Foundation
import SwiftUI

struct ActorPickerLabel: View {
    var actor: String

    var body: some View {
        Text(actor)
            .font(.system(size: 25)) // Set the desired font size here
            .foregroundColor(.white)
    }
}
