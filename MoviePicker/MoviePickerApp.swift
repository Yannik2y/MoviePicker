//
//  MoviePickerApp.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

struct MoviePickerApp: View {
    @StateObject var contentViewVM = PickerViewModel()
    @StateObject var dadModeViewVM = DadModeViewModel()
    @StateObject var customPickerVM = CustomPickerViewModel()

    @State private var currentView: CurrentView = .contentView
    @State private var isShowingMenu = false
    @State private var showingOnboarding = false
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            switch currentView {
            case .contentView:
                ContentView(viewModel: contentViewVM)
            case .dadModeView:
                DadModeView(viewModel: dadModeViewVM)
            case .customPickerView:
                CustomPickerView(viewModel: customPickerVM)
            }
            
            // Menu button overlay - ensure it's on top
            VStack {
                HStack {
                    MenuButton(action: { isShowingMenu.toggle() }, isDadMode: currentView == .dadModeView)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, Layout.menuButtonTopSpacing)
            .zIndex(10) // Ensure menu button is above everything
            .allowsHitTesting(true) // Explicitly allow touch interaction

            if isShowingMenu {
                MenuView(isShowingMenu: $isShowingMenu, currentView: $currentView)
                    .zIndex(20) // Ensure menu is above everything
            }
            
            // Triple-tap detector for Custom Picker - adaptive for iPad
            if currentView == .customPickerView {
                VStack {
                    Spacer()
                        .frame(height: DeviceHelper.isiPad ? 300 : 200) // More space on iPad
                    
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .frame(width: DeviceHelper.isiPad ? 150 : 100, height: DeviceHelper.isiPad ? 150 : 100)
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: DeviceHelper.isiPad ? 2 : 1)
                                .frame(width: DeviceHelper.isiPad ? 150 : 100, height: DeviceHelper.isiPad ? 150 : 100)
                        }
                        .onTapGesture(count: 3) {
                            customPickerVM.showingSettings = true
                            HapticManager.shared.success()
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
                .zIndex(10000) // Highest possible
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isPresented: $showingOnboarding)
        }
        .overlay(
            // TMDB Attribution (required by TMDB terms)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Powered by")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Image("tmdb_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                    }
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
                }
            }
        )
        .onChange(of: isShowingMenu) { oldValue, newValue in
            // Clear all pickers when menu is opened
            if newValue {
                contentViewVM.randomMovie = nil
                contentViewVM.triggerScrolling = false
                dadModeViewVM.randomMovie = nil
                dadModeViewVM.triggerScrolling = false
                customPickerVM.randomMovie = nil
                customPickerVM.triggerScrolling = false
            }
        }
        .onChange(of: currentView) { oldValue, newValue in
            // Clear picker when switching modes
            contentViewVM.randomMovie = nil
            contentViewVM.triggerScrolling = false
            dadModeViewVM.randomMovie = nil
            dadModeViewVM.triggerScrolling = false
            customPickerVM.randomMovie = nil
            customPickerVM.triggerScrolling = false
        }
        .onAppear {
            // Show onboarding on first launch
            if !hasCompletedOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showingOnboarding = true
                }
            }
        }
    }
}

struct MoviePickerApp_Previews: PreviewProvider {
    static var previews: some View {
        MoviePickerApp()
    }
}
