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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        GeometryReader { geo in
            let metrics = AdaptiveLayoutMetrics(
                horizontalSizeClass: horizontalSizeClass,
                verticalSizeClass: verticalSizeClass,
                size: geo.size
            )
            
            ZStack {
                switch currentView {
                case .contentView:
                    ContentView(viewModel: contentViewVM)
                case .dadModeView:
                    DadModeView(viewModel: dadModeViewVM)
                case .customPickerView:
                    CustomPickerView(viewModel: customPickerVM)
                }
                
                // Menu button
                VStack {
                    HStack {
                        MenuButton(action: { isShowingMenu.toggle() }, isDadMode: currentView == .dadModeView)
                            .hoverEffect(.highlight)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 8)
                .zIndex(10)
                
                if isShowingMenu {
                    menuOverlay(metrics: metrics)
                        .zIndex(20)
                }
                
                if currentView == .customPickerView {
                    secretHitTarget(metrics: metrics, in: geo.size)
                        .zIndex(15)
                }
                
                tmdbAttribution
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isPresented: $showingOnboarding)
                .presentationDetents(horizontalSizeClass == .regular ? [.large] : [.large])
        }
        .onChange(of: isShowingMenu) { _, newValue in
            if newValue { resetAllPickerState() }
        }
        .onChange(of: currentView) { _, _ in
            resetAllPickerState()
        }
        .onAppear {
            if !hasCompletedOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showingOnboarding = true
                }
            }
            // UITesting launch argument
            if ProcessInfo.processInfo.arguments.contains("-UITesting") {
                hasCompletedOnboarding = true
                showingOnboarding = false
            }
            if ProcessInfo.processInfo.arguments.contains("-SkipOnboarding") {
                hasCompletedOnboarding = true
            }
        }
    }
    
    @ViewBuilder
    private func menuOverlay(metrics: AdaptiveLayoutMetrics) -> some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isShowingMenu = false }
            
            if metrics.isRegularWidth {
                MenuView(isShowingMenu: $isShowingMenu, currentView: $currentView)
                    .frame(width: metrics.menuPanelWidth)
                    .frame(maxHeight: .infinity)
                    .background(AppColors.menuBackground)
                    .transition(.move(edge: .leading))
            } else {
                MenuView(isShowingMenu: $isShowingMenu, currentView: $currentView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(AppColors.menuBackground)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isShowingMenu)
    }
    
    private func secretHitTarget(metrics: AdaptiveLayoutMetrics, in size: CGSize) -> some View {
        let hit = metrics.secretHitSize
        return VStack {
            Spacer()
                .frame(height: size.height * 0.42)
            HStack {
                Spacer()
                Circle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: hit, height: hit)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .contentShape(Circle())
                    .onTapGesture(count: 3) {
                        customPickerVM.showingSettings = true
                        HapticManager.shared.success()
                    }
                    .accessibilityHidden(true)
                Spacer()
            }
            Spacer()
        }
        .allowsHitTesting(true)
    }
    
    private var tmdbAttribution: some View {
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
        .allowsHitTesting(false)
    }

    private func resetAllPickerState() {
        contentViewVM.targetMovie = nil
        contentViewVM.randomMovie = nil
        contentViewVM.triggerScrolling = false
        dadModeViewVM.targetMovie = nil
        dadModeViewVM.randomMovie = nil
        dadModeViewVM.triggerScrolling = false
        customPickerVM.targetMovie = nil
        customPickerVM.randomMovie = nil
        customPickerVM.triggerScrolling = false
    }
}

struct MoviePickerApp_Previews: PreviewProvider {
    static var previews: some View {
        MoviePickerApp()
    }
}
