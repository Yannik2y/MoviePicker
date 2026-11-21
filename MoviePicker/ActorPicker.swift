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
                .font(.title2)
                .foregroundColor(Theme.inkPrimary.opacity(0.9))
            
            Text(L10n.Filter.label)
                .font(.title3)
                .foregroundColor(Theme.inkPrimary.opacity(0.9))

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
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Theme.inkPrimary)
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Theme.inkTertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
            }
            .accessibilityLabel("\(L10n.Filter.label) \(selectedActor)")
        }
        .padding()
        .hoverEffect(.highlight)
    }
}
