//
//  MovieSearchView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// View for searching and selecting custom movies from TMDB
struct MovieSearchView: View {
    @Environment(\.appDependencies) private var dependencies
    var clearPickerCallback: (() -> Void)?
    
    var body: some View {
        MovieSearchBody(
            tmdbService: dependencies.tmdb,
            storage: dependencies.customStorage,
            haptics: dependencies.haptics,
            clearPickerCallback: clearPickerCallback
        )
    }
}

private struct MovieSearchBody: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var tmdbService: TMDBService
    @ObservedObject var storage: CustomMovieStorage
    let haptics: HapticManager
    var clearPickerCallback: (() -> Void)?
    
    @State private var searchText = ""
    @State private var searchResults: [TMDBMovie] = []
    @State private var isSearching = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.stageBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Theme.inkTertiary)
                        TextField(L10n.Search.placeholder, text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(Theme.inkPrimary)
                            .textInputAutocapitalization(.never)
                            .tint(Theme.modeCustom)
                            .focused($isSearchFocused)
                            .accessibilityLabel(L10n.Search.placeholder)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                searchResults = []
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Theme.inkTertiary)
                            }
                            .accessibilityLabel(L10n.Common.close)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.listCornerRadius, style: .continuous))
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    if let error = tmdbService.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(Theme.danger)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let currentMovie = storage.selectedMovie {
                        currentSelectionCard(currentMovie)
                    }
                    
                    Divider().background(Theme.inkTertiary.opacity(0.4))
                    
                    resultsArea
                }
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(L10n.Search.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        haptics.lightImpact()
                        dismiss()
                    }
                }
            }
            .task(id: searchText) {
                await performSearch()
            }
            .onAppear {
                isSearchFocused = true
                if !Config.hasValidAPIKey {
                    tmdbService.errorMessage = TMDBError.noAPIKey.localizedDescription
                }
            }
        }
    }
    
    @ViewBuilder
    private func currentSelectionCard(_ currentMovie: CustomMovieData) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text(L10n.Search.currentSelection)
                    .font(.subheadline)
                    .foregroundColor(Theme.inkSecondary)
                Spacer()
            }
            
            HStack(spacing: 12) {
                if let posterImage = storage.posterImage {
                    Image(uiImage: posterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 50, height: 75)
                        .overlay(Image(systemName: "film.fill").foregroundColor(Theme.inkTertiary))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentMovie.title)
                        .font(.headline)
                        .foregroundColor(Theme.inkPrimary)
                    Text(currentMovie.actor)
                        .font(.caption)
                        .foregroundColor(Theme.inkSecondary)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private var resultsArea: some View {
        if isSearching {
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Text(L10n.Search.searching)
                    .foregroundColor(Theme.inkSecondary)
                    .padding(.top)
                Spacer()
            }
        } else if searchResults.isEmpty && !searchText.isEmpty {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "film.slash")
                    .font(.largeTitle)
                    .foregroundColor(Theme.inkTertiary)
                Text(L10n.Search.noResults)
                    .font(.headline)
                    .foregroundColor(Theme.inkPrimary)
                Text(L10n.Search.tryDifferent)
                    .font(.subheadline)
                    .foregroundColor(Theme.inkTertiary)
                Spacer()
            }
        } else if searchResults.isEmpty {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "popcorn.fill")
                    .font(.largeTitle)
                    .foregroundColor(Theme.modeCustom)
                Text(L10n.Search.searchAny)
                    .font(.headline)
                    .foregroundColor(Theme.inkPrimary)
                Text(L10n.Search.prankHint)
                    .font(.subheadline)
                    .foregroundColor(Theme.inkTertiary)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(searchResults) { movie in
                        MovieSearchResultRow(movie: movie) {
                            selectMovie(movie)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func performSearch() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        tmdbService.errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            try Task.checkCancellation()
            let results = try await tmdbService.searchMovies(query: query)
            try Task.checkCancellation()
            searchResults = results
        } catch is CancellationError {
            // superseded
        } catch {
            AppLogger.error("Search failed for '\(query)'", error: error, category: .network)
            tmdbService.errorMessage = error.localizedDescription
        }
        
        isSearching = false
    }
    
    private func selectMovie(_ movie: TMDBMovie) {
        haptics.mediumImpact()
        
        Task {
            do {
                let cast = try await tmdbService.getMovieCredits(movieId: movie.id)
                var posterData: Data?
                if let posterURL = movie.posterURL {
                    posterData = try? await URLSession.shared.data(from: posterURL).0
                }
                storage.saveMovie(movie, cast: cast, posterData: posterData)
                clearPickerCallback?()
                haptics.success()
                try await Task.sleep(nanoseconds: 500_000_000)
                dismiss()
            } catch {
                AppLogger.error("Failed to select movie '\(movie.title)'", error: error, category: .network)
                tmdbService.errorMessage = error.localizedDescription
                haptics.error()
            }
        }
    }
}

struct MovieSearchResultRow: View {
    let movie: TMDBMovie
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Group {
                    if let posterURL = movie.posterURL {
                        AsyncImage(url: posterURL) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .empty:
                                ProgressView()
                            default:
                                Image(systemName: "film.fill")
                                    .foregroundColor(Theme.inkTertiary)
                            }
                        }
                    } else {
                        Image(systemName: "film.fill")
                            .foregroundColor(Theme.inkTertiary)
                    }
                }
                .frame(width: 60, height: 90)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(Theme.inkPrimary)
                    if movie.year > 0 {
                        Text(verbatim: String(movie.year))
                            .font(.subheadline)
                            .foregroundColor(Theme.inkSecondary)
                    }
                    if let overview = movie.overview, !overview.isEmpty {
                        Text(overview)
                            .font(.caption)
                            .foregroundColor(Theme.inkTertiary)
                            .lineLimit(2)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.inkTertiary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.listCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(movie.title), \(movie.year > 0 ? String(movie.year) : "")")
    }
}
