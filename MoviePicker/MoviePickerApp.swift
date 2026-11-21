//
//  MoviePickerApp.swift
//  MoviePicker
//
//  Root shell: iPhone TabView + iPad NavigationSplitView.
//  Bond Picker is the default Pick mode.
//

import SwiftUI

enum AppTab: Hashable {
    case pick
    case library
    case more
}

enum SidebarItem: Hashable {
    case bond
    case custom
    case dad
    case library
    case instructions
    case about
}

struct MoviePickerApp: View {
    @Environment(\.appDependencies) private var dependencies
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @StateObject private var contentViewVM: PickerViewModel
    @StateObject private var dadModeViewVM: DadModeViewModel
    @StateObject private var customPickerVM: CustomPickerViewModel
    
    @State private var selectedTab: AppTab = .pick
    @State private var pickMode: CurrentView = .contentView
    @State private var sidebarSelection: SidebarItem? = .bond
    @State private var showingOnboarding = false
    @State private var showingInstructions = false
    @State private var showingAbout = false
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        let deps = AppDependencies.live
        _contentViewVM = StateObject(wrappedValue: PickerViewModel(
            movieService: deps.catalog,
            history: deps.history
        ))
        _dadModeViewVM = StateObject(wrappedValue: DadModeViewModel(
            movieService: deps.catalog,
            history: deps.history
        ))
        _customPickerVM = StateObject(wrappedValue: CustomPickerViewModel(
            movieService: deps.catalog,
            storage: deps.customStorage,
            history: deps.history
        ))
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                ipadSplitView
            } else {
                iphoneTabView
            }
        }
        .preferredColorScheme(.dark)
        .tint(Theme.accent)
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isPresented: $showingOnboarding)
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showingInstructions) {
            InstructionsView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .onChange(of: pickMode) { _, _ in
            resetPickerRevealState()
        }
        .onAppear(perform: handleLaunch)
    }
    
    // MARK: - iPhone
    
    private var iphoneTabView: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                pickStage
                    .navigationTitle(L10n.About.appName)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { pickToolbar }
            }
            .tabItem { Label(L10n.Menu.pick, systemImage: "film") }
            .tag(AppTab.pick)
            
            NavigationStack {
                HistoryView()
            }
            .tabItem { Label(L10n.Menu.library, systemImage: "books.vertical") }
            .tag(AppTab.library)
            
            NavigationStack {
                moreList
                    .navigationTitle(L10n.Menu.more)
            }
            .tabItem { Label(L10n.Menu.more, systemImage: "ellipsis.circle") }
            .tag(AppTab.more)
        }
    }
    
    // MARK: - iPad
    
    private var ipadSplitView: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                Section(L10n.Menu.pick) {
                    Label(L10n.Menu.bondPicker, systemImage: "scope")
                        .tag(SidebarItem.bond)
                    Label(L10n.Menu.moviePicker, systemImage: "target")
                        .tag(SidebarItem.custom)
                    Label(L10n.Menu.dadMode, systemImage: "trophy.fill")
                        .tag(SidebarItem.dad)
                }
                Section {
                    Label(L10n.Menu.library, systemImage: "books.vertical")
                        .tag(SidebarItem.library)
                    Label(L10n.Menu.instructions, systemImage: "questionmark.circle")
                        .tag(SidebarItem.instructions)
                    Label(L10n.About.title, systemImage: "info.circle")
                        .tag(SidebarItem.about)
                }
            }
            .navigationTitle(L10n.About.appName)
        } detail: {
            NavigationStack {
                detailContent
                    .toolbar {
                        if pickMode == .customPickerView {
                            ToolbarItem(placement: .topBarTrailing) {
                                hostToolsMenu
                            }
                        }
                    }
            }
        }
        .onChange(of: sidebarSelection) { _, item in
            guard let item else { return }
            switch item {
            case .bond:
                pickMode = .contentView
            case .custom:
                pickMode = .customPickerView
            case .dad:
                pickMode = .dadModeView
            case .library, .instructions, .about:
                break
            }
        }
    }
    
    @ViewBuilder
    private var detailContent: some View {
        switch sidebarSelection {
        case .library:
            HistoryView()
        case .instructions:
            InstructionsView()
        case .about:
            AboutView()
        case .bond, .custom, .dad, .none:
            pickStage
        }
    }
    
    // MARK: - Pick stage
    
    private var pickStage: some View {
        VStack(spacing: 0) {
            Picker(L10n.Menu.title, selection: $pickMode) {
                Text(L10n.Menu.bondPicker).tag(CurrentView.contentView)
                Text(L10n.Menu.moviePicker).tag(CurrentView.customPickerView)
                Text(L10n.Menu.dadMode).tag(CurrentView.dadModeView)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
            .accessibilityLabel(L10n.Menu.title)
            
            modeContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background {
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .overlay(Theme.appScrim)
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(L10n.TMDB.poweredBy)
                        .font(.caption2)
                        .foregroundColor(Theme.inkTertiary)
                    Image("tmdb_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 10)
                }
                .padding(.trailing, 12)
                .padding(.bottom, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(L10n.TMDB.poweredBy) TMDB")
            }
            .allowsHitTesting(false)
        }
    }
    
    @ViewBuilder
    private var modeContent: some View {
        switch pickMode {
        case .contentView:
            ContentView(viewModel: contentViewVM)
        case .dadModeView:
            DadModeView(viewModel: dadModeViewVM)
        case .customPickerView:
            CustomPickerView(viewModel: customPickerVM)
        }
    }
    
    @ToolbarContentBuilder
    private var pickToolbar: some ToolbarContent {
        if pickMode == .customPickerView {
            ToolbarItem(placement: .topBarTrailing) {
                hostToolsMenu
            }
        }
    }
    
    private var hostToolsMenu: some View {
        Menu {
            Button {
                customPickerVM.openSettings()
                dependencies.haptics.success()
            } label: {
                Label(L10n.Menu.hostTools, systemImage: "slider.horizontal.3")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .accessibilityLabel(L10n.Accessibility.hostTools)
    }
    
    private var moreList: some View {
        List {
            Button {
                showingInstructions = true
            } label: {
                Label(L10n.Menu.instructions, systemImage: "questionmark.circle")
            }
            Button {
                showingAbout = true
            } label: {
                Label(L10n.About.title, systemImage: "info.circle")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.stageBackground)
    }
    
    // MARK: - Lifecycle
    
    private func handleLaunch() {
        if ProcessInfo.processInfo.arguments.contains("-UITesting")
            || ProcessInfo.processInfo.arguments.contains("-SkipOnboarding") {
            hasCompletedOnboarding = true
            showingOnboarding = false
        } else if !hasCompletedOnboarding {
            showingOnboarding = true
        }
    }
    
    /// Reset reveal only when switching modes — not when opening Library
    private func resetPickerRevealState() {
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
            .environment(\.appDependencies, AppDependencies.live)
    }
}
