//
//  MoviePickerTests.swift
//  MoviePickerTests
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import XCTest
@testable import MoviePicker

final class MoviePickerTests: XCTestCase {

    // MARK: - Movie Tests
    
    func testMovieEquality() {
        let movie1 = Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action", imdbRating: 7.7, poster: "goldfinger")
        let movie2 = Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action", imdbRating: 7.7, poster: "goldfinger")
        let movie3 = Movie(title: "Skyfall", year: 2012, actor: "Daniel Craig", genre: "Action", imdbRating: 7.7, poster: "skyfall")
        
        XCTAssertEqual(movie1, movie2)
        XCTAssertNotEqual(movie1, movie3)
        XCTAssertEqual(movie1.id, "Goldfinger-1964")
    }
    
    func testMovieBondActorProperty() {
        let bondMovie = Movie(title: "Casino Royale", year: 2006, actor: "Daniel Craig", genre: "Action", imdbRating: 8.0, poster: "casino_royale")
        let specialMovie = Movie(title: "FIFA WM 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014")
        
        XCTAssertEqual(bondMovie.bondActor, .danielCraig)
        XCTAssertNil(specialMovie.bondActor)
    }
    
    func testMovieStarsMethod() {
        let movie = Movie(title: "GoldenEye", year: 1995, actor: "Pierce Brosnan", genre: "Action", imdbRating: 7.2, poster: "goldeneye")
        XCTAssertTrue(movie.stars(.pierceBrosnan))
        XCTAssertFalse(movie.stars(.seanConnery))
    }
    
    // MARK: - BondActor Tests
    
    func testBondActorCount() {
        XCTAssertEqual(BondActor.allCases.count, 6)
    }
    
    func testBondActorRawValues() {
        XCTAssertEqual(BondActor.seanConnery.rawValue, "Sean Connery")
        XCTAssertEqual(BondActor.danielCraig.rawValue, "Daniel Craig")
    }
    
    func testBondActorAllWithFilter() {
        let allWithFilter = BondActor.allWithFilter
        XCTAssertEqual(allWithFilter.count, 7)
        XCTAssertEqual(allWithFilter.first, L10n.Filter.allActors)
        XCTAssertTrue(allWithFilter.contains("Sean Connery"))
    }
    
    // MARK: - MovieService Tests
    
    @MainActor
    func testMovieServiceBondMovies() {
        let service = MovieService.shared
        let bondMovies = service.bondMovies
        XCTAssertGreaterThan(bondMovies.count, 0)
        XCTAssertFalse(bondMovies.contains { $0.title == "WM-Halbfinale 2014" })
        XCTAssertEqual(bondMovies.count, 25)
    }
    
    @MainActor
    func testMovieServiceFilterByEnum() {
        let service = MovieService.shared
        let danielCraigMovies = service.filterMovies(by: .danielCraig)
        XCTAssertEqual(danielCraigMovies.count, 5)
        let rogerMooreMovies = service.filterMovies(by: .rogerMoore)
        XCTAssertEqual(rogerMooreMovies.count, 7)
    }
    
    @MainActor
    func testMovieServiceFilterByAllActorsLocalized() {
        let service = MovieService.shared
        let allMovies = service.filterMovies(by: L10n.Filter.allActors)
        XCTAssertEqual(allMovies.count, service.bondMovies.count)
    }
    
    @MainActor
    func testMovieServiceFifaMovie() {
        let service = MovieService.shared
        let fifaMovie = service.fifaMovie
        XCTAssertNotNil(fifaMovie)
        XCTAssertEqual(fifaMovie?.title, "WM-Halbfinale 2014")
        XCTAssertEqual(fifaMovie?.year, 2014)
    }
    
    // MARK: - PickerViewModel Tests
    
    @MainActor
    func testPickerViewModelInitialization() {
        let viewModel = PickerViewModel()
        XCTAssertEqual(viewModel.selectedActor, L10n.Filter.allActors)
        XCTAssertNil(viewModel.targetMovie)
        XCTAssertFalse(viewModel.triggerScrolling)
        XCTAssertGreaterThan(viewModel.filteredMovies.count, 0)
    }
    
    @MainActor
    func testPickerViewModelSelectMovieSeedsRevealState() {
        let viewModel = PickerViewModel()
        viewModel.selectMovie()
        XCTAssertNotNil(viewModel.targetMovie)
        XCTAssertTrue(viewModel.triggerScrolling)
        // Intentional: seed first scroll frame so the card never flashes empty
        XCTAssertNotNil(viewModel.randomMovie)
    }
    
    @MainActor
    func testBondCatalogHasStableTMDBIds() {
        let bond = Movies.filter { $0.genre != "Sports" }
        XCTAssertEqual(bond.count, 25)
        XCTAssertTrue(bond.allSatisfy { $0.tmdbId != nil })
        XCTAssertEqual(Movies.first { $0.title == "Dr. No" }?.tmdbId, 646)
        XCTAssertEqual(Movies.first { $0.title == "Skyfall" }?.tmdbId, 37724)
    }
    
    @MainActor
    func testHistoryClearFavoritesKeepsNonFavorites() {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let history = MovieHistory(
            fileURL: dir.appendingPathComponent("history.json"),
            defaults: UserDefaults(suiteName: UUID().uuidString)!
        )
        let bond = Movies[0]
        let dad = Movies.first { $0.title == MovieConstants.fifaWM2014Title }!
        history.addToHistory(movie: bond, mode: .bondPicker)
        history.addToHistory(movie: dad, mode: .dadMode)
        let favId = history.entries[0].id
        history.toggleFavorite(id: favId)
        XCTAssertEqual(history.favorites.count, 1)
        history.clearFavorites()
        XCTAssertEqual(history.favorites.count, 0)
        XCTAssertEqual(history.entries.count, 1)
    }
    
    @MainActor
    func testPickerViewModelPreventRapidSelections() {
        let viewModel = PickerViewModel()
        viewModel.selectMovie()
        let firstTarget = viewModel.targetMovie
        viewModel.selectMovie()
        XCTAssertEqual(viewModel.targetMovie, firstTarget)
    }
    
    @MainActor
    func testPickerViewModelErrorHandling() {
        let viewModel = PickerViewModel()
        viewModel.selectedActor = "NonExistent Actor"
        viewModel.updateFilteredMovies()
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.filteredMovies.count, 0)
    }
    
    // MARK: - DadModeViewModel Tests
    
    @MainActor
    func testDadModeViewModelAlwaysSelectsWM2014() {
        let viewModel = DadModeViewModel()
        for _ in 0..<5 {
            viewModel.targetMovie = nil
            viewModel.triggerScrolling = false
            viewModel.selectMovie()
            XCTAssertEqual(viewModel.targetMovie?.title, "WM-Halbfinale 2014")
        }
    }
    
    // MARK: - CustomPickerViewModel Tests
    
    @MainActor
    func testCustomPickerViewModelSelectsCustomMovie() {
        let storage = CustomMovieStorage.shared
        storage.loadSelectedMovie()
        let viewModel = CustomPickerViewModel(storage: storage)
        guard viewModel.customMovie != nil else {
            XCTFail("No custom movie available")
            return
        }
        viewModel.selectMovie()
        XCTAssertEqual(viewModel.targetMovie?.title, viewModel.customMovie?.title)
        XCTAssertTrue(viewModel.triggerScrolling)
    }
    
    @MainActor
    func testCustomPickerViewModelErrorWhenNoCustomMovie() {
        let storage = CustomMovieStorage.shared
        storage.clearSelection()
        let viewModel = CustomPickerViewModel(storage: storage)
        viewModel.selectMovie()
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.targetMovie)
        storage.loadSelectedMovie()
    }
    
    @MainActor
    func testCustomMovieDataToMovie() {
        let movieData = CustomMovieData(
            title: "Test Movie",
            year: 2020,
            actor: "Test Actor",
            tmdbId: 12345
        )
        let movie = movieData.toMovie()
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.genre, "Custom")
        XCTAssertEqual(movie.id, "tmdb:12345")
    }
    
    // MARK: - Logger / Protocol
    
    func testLoggerConvenienceMethods() {
        AppLogger.debug("Test debug message")
        AppLogger.info("Test info message", category: .network)
        let testError = NSError(domain: "test", code: 42)
        AppLogger.error("Test error", error: testError, category: .storage)
    }
    
    @MainActor
    func testViewModelsConformToProtocol() {
        let _: any MoviePickerViewModelProtocol = PickerViewModel()
        let _: any MoviePickerViewModelProtocol = DadModeViewModel()
        let _: any MoviePickerViewModelProtocol = CustomPickerViewModel()
    }
    
    @MainActor
    func testFullPickerFlow() {
        let viewModel = PickerViewModel()
        XCTAssertEqual(viewModel.filteredMovies.count, 25)
        viewModel.selectedActor = "Pierce Brosnan"
        viewModel.updateFilteredMovies()
        XCTAssertEqual(viewModel.filteredMovies.count, 4)
        viewModel.selectMovie()
        XCTAssertTrue(viewModel.targetMovie?.stars(.pierceBrosnan) ?? false)
    }
}
