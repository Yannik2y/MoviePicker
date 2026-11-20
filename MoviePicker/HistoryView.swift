//
//  HistoryView.swift
//  MoviePicker
//
//  Displays movie selection history and favorites
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var history = MovieHistory.shared
    @State private var selectedTab = 0
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Picker("View", selection: $selectedTab) {
                        Text(L10n.History.tabHistory).tag(0)
                        Text(L10n.History.tabFavorites).tag(1)
                        Text(L10n.History.tabStats).tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    TabView(selection: $selectedTab) {
                        HistoryListView(entries: history.entries, history: history)
                            .tag(0)
                        HistoryListView(entries: history.favorites, history: history, showEmptyFavorites: true)
                            .tag(1)
                        StatsView(stats: history.stats, regularWidth: horizontalSizeClass == .regular)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .frame(maxWidth: horizontalSizeClass == .regular ? 900 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(L10n.History.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.Common.close) { dismiss() }
                        .foregroundColor(.cyan)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab < 2 {
                        Menu {
                            Button(role: .destructive, action: { showingClearAlert = true }) {
                                Label(L10n.History.clear, systemImage: "trash")
                            }
                            if selectedTab == 0 {
                                Button(action: { history.clearNonFavorites() }) {
                                    Label(L10n.History.clearNonFavorites, systemImage: "star.slash")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.cyan)
                        }
                        .accessibilityLabel(L10n.History.clear)
                    }
                }
            }
            .alert(L10n.History.clearConfirmTitle, isPresented: $showingClearAlert) {
                Button(L10n.History.cancel, role: .cancel) { }
                Button(L10n.History.clearAction, role: .destructive) {
                    if selectedTab == 0 {
                        history.clearHistory()
                    } else {
                        history.clearNonFavorites()
                    }
                }
            } message: {
                Text(selectedTab == 0
                     ? L10n.History.clearConfirmAll
                     : L10n.History.clearConfirmFavorites)
            }
        }
    }
}

struct HistoryListView: View {
    let entries: [MovieHistoryEntry]
    @ObservedObject var history: MovieHistory
    var showEmptyFavorites = false
    
    var body: some View {
        ScrollView {
            if entries.isEmpty {
                VStack(spacing: 24) {
                    Spacer(minLength: 80)
                    Image(systemName: showEmptyFavorites ? "star.slash" : "clock")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.4))
                    Text(showEmptyFavorites ? L10n.History.emptyFavoritesTitle : L10n.History.emptyTitle)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text(showEmptyFavorites ? L10n.History.emptyFavoritesSubtitle : L10n.History.emptySubtitle)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(entries) { entry in
                        HistoryEntryRow(entry: entry, history: history)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
}

struct HistoryEntryRow: View {
    let entry: MovieHistoryEntry
    @ObservedObject var history: MovieHistory
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.25))
                    .frame(width: 50, height: 50)
                Image(systemName: modeIcon)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(modeColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.movieTitle)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Text(entry.actor)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    Text("•")
                        .foregroundColor(.white.opacity(0.6))
                    Text(String(entry.movieYear))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                Text(entry.mode.rawValue)
                    .font(.caption.weight(.medium))
                    .foregroundColor(modeColor)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: { history.toggleFavorite(id: entry.id) }) {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundColor(entry.isFavorite ? .yellow : .white.opacity(0.6))
                }
                .accessibilityLabel(entry.isFavorite ? L10n.History.tabFavorites : L10n.History.tabFavorites)
                
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.cyan)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
        .accessibilityElement(children: .contain)
    }
    
    private var modeIcon: String {
        switch entry.mode {
        case .bondPicker: return "scope"
        case .customPicker: return "target"
        case .dadMode: return "trophy.fill"
        }
    }
    
    private var modeColor: Color {
        switch entry.mode {
        case .bondPicker: return .white
        case .customPicker: return .cyan
        case .dadMode: return .yellow
        }
    }
    
    private var shareText: String {
        L10n.History.share(
            title: entry.movieTitle,
            year: String(entry.movieYear),
            actor: entry.actor,
            mode: entry.mode.rawValue
        )
    }
}

struct StatsView: View {
    let stats: HistoryStats
    var regularWidth: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(L10n.History.statsTitle)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                let cards = [
                    (icon: "film.fill", title: L10n.History.statsTotal, value: "\(stats.totalSelections)", color: Color.white),
                    (icon: "star.fill", title: L10n.History.statsFavorites, value: "\(stats.favoriteCount)", color: Color.yellow),
                    (icon: "person.fill", title: L10n.History.statsMostActor, value: stats.mostSelectedActor, color: Color.cyan),
                    (icon: modeIcon(for: stats.mostUsedMode), title: L10n.History.statsFavoriteMode, value: stats.mostUsedMode.rawValue, color: modeColor(for: stats.mostUsedMode))
                ]
                
                if regularWidth {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                            StatCard(icon: card.icon, title: card.title, value: card.value, color: card.color)
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    VStack(spacing: 16) {
                        ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                            StatCard(icon: card.icon, title: card.title, value: card.value, color: card.color)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private func modeIcon(for mode: PickerMode) -> String {
        switch mode {
        case .bondPicker: return "scope"
        case .customPicker: return "target"
        case .dadMode: return "trophy.fill"
        }
    }
    
    private func modeColor(for mode: PickerMode) -> Color {
        switch mode {
        case .bondPicker: return .white
        case .customPicker: return .cyan
        case .dadMode: return .yellow
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 70, height: 70)
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white.opacity(0.8))
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
