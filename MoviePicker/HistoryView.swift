//
//  HistoryView.swift
//  MoviePicker
//
//  Displays movie selection history and favorites
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var history = MovieHistory.shared
    @State private var selectedTab = 0
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Tab selector with better styling
                    Picker("View", selection: $selectedTab) {
                        Text("History").tag(0)
                        Text("Favorites").tag(1)
                        Text("Stats").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        HistoryListView(entries: history.entries, history: history)
                            .tag(0)
                        
                        HistoryListView(entries: history.favorites, history: history, showEmptyFavorites: true)
                            .tag(1)
                        
                        StatsView(stats: history.stats)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationTitle("History & Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.Common.close) {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                    .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab < 2 {
                        Menu {
                            Button(role: .destructive, action: {
                                showingClearAlert = true
                            }) {
                                Label("Clear History", systemImage: "trash")
                            }
                            
                            if selectedTab == 0 {
                                Button(action: {
                                    history.clearNonFavorites()
                                }) {
                                    Label("Clear Non-Favorites", systemImage: "star.slash")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.cyan)
                                .font(.title2)
                        }
                    }
                }
            }
            .alert("Clear History?", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    if selectedTab == 0 {
                        history.clearHistory()
                    } else {
                        history.clearNonFavorites()
                    }
                }
            } message: {
                Text(selectedTab == 0
                     ? "This will permanently delete all history entries."
                     : "This will permanently delete all favorite entries.")
            }
        }
    }
}

/// List view for history entries
struct HistoryListView: View {
    let entries: [MovieHistoryEntry]
    @ObservedObject var history: MovieHistory
    var showEmptyFavorites = false
    
    var body: some View {
        ScrollView {
            if entries.isEmpty {
                VStack(spacing: 24) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 120, height: 120)
                        Image(systemName: showEmptyFavorites ? "star.slash" : "clock")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    
                    VStack(spacing: 8) {
                        Text(showEmptyFavorites ? "No Favorites" : "No History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(showEmptyFavorites
                             ? "Movies you favorite will appear here"
                             : "Your movie selections will appear here")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

/// Individual history entry row
struct HistoryEntryRow: View {
    let entry: MovieHistoryEntry
    @ObservedObject var history: MovieHistory
    @State private var showingShareSheet = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Mode indicator with better visibility
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.25))
                    .frame(width: 50, height: 50)
                Image(systemName: modeIcon)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(modeColor)
            }
            
            // Movie info with better spacing and contrast
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.movieTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 6) {
                    Text(entry.actor)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    Text("•")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.subheadline)
                    Text(String(entry.movieYear))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(entry.mode.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(modeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(modeColor.opacity(0.15))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            // Actions with better touch targets
            VStack(spacing: 12) {
                Button(action: {
                    history.toggleFavorite(id: entry.id)
                }) {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundColor(entry.isFavorite ? .yellow : .white.opacity(0.6))
                }
                .frame(width: 32, height: 32)
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.cyan)
                }
                .frame(width: 32, height: 32)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [shareText])
        }
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
        "I picked '\(entry.movieTitle)' (\(String(entry.movieYear))) starring \(entry.actor) using \(entry.mode.rawValue)! 🎬"
    }
}

/// Statistics view
struct StatsView: View {
    let stats: HistoryStats
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header with better styling
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.15))
                            .frame(width: 100, height: 100)
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.cyan)
                    }
                    
                    Text("Your Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                // Stats cards with better spacing
                VStack(spacing: 20) {
                    StatCard(
                        icon: "film.fill",
                        title: "Total Selections",
                        value: "\(stats.totalSelections)",
                        color: .white
                    )
                    
                    StatCard(
                        icon: "star.fill",
                        title: "Favorites",
                        value: "\(stats.favoriteCount)",
                        color: .yellow
                    )
                    
                    StatCard(
                        icon: "person.fill",
                        title: "Most Selected Actor",
                        value: stats.mostSelectedActor,
                        color: .cyan
                    )
                    
                    StatCard(
                        icon: modeIcon(for: stats.mostUsedMode),
                        title: "Favorite Mode",
                        value: stats.mostUsedMode.rawValue,
                        color: modeColor(for: stats.mostUsedMode)
                    )
                }
                .padding(.horizontal, 16)
                
                Spacer(minLength: 50)
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

/// Stat card component
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
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

/// Share sheet wrapper for UIKit
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

