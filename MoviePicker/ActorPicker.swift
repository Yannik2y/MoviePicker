//
//  ActorPicker.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import Foundation
import SwiftUI

struct ActorPicker: View {
    @Binding var selectedActor: String
    let allActors: [String]

    var body: some View {
        HStack {
            Text("Filter by Actor:")
                .font(.system(size: 25))
                .foregroundColor(.white)

            Menu {
                ForEach(allActors, id: \.self) { actor in
                    Button(action: {
                        selectedActor = actor
                    }) {
                        Text(actor)
                    }
                }
            } label: {
                Text(selectedActor)
                    .font(.system(size: 25)) // Set the desired font size here
                    .foregroundColor(.white)
                    .padding(.leading)
            }
        }
        .padding()
    }
}
