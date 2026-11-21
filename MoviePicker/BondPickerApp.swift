//
//  BondPickerApp.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 18.05.23.
//

import SwiftUI

@main
struct BondPickerApp: App {
    private let dependencies = AppDependencies.live
    
    var body: some Scene {
        WindowGroup {
            MoviePickerApp()
                .environment(\.appDependencies, dependencies)
                .environmentObject(dependencies)
                .preferredColorScheme(.dark)
                .tint(Theme.accent)
        }
    }
}
