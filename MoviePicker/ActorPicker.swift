//
//  ActorPicker.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import SwiftUI

struct ActorPicker: View {
    @Binding var selectedActor: String
    let allActors: [String]

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.9))
            
            Text(L10n.Filter.label)
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.9))

            Menu {
                ForEach(allActors, id: \.self) { actor in
                    Button(action: {
                        selectedActor = actor
                    }) {
                        HStack {
                            if actor == selectedActor {
                                Image(systemName: "checkmark")
                            }
                            Text(actor)
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedActor)
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
            }
        }
        .padding()
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
