//
//  L10n.swift
//  Auto-generated from Localizable.strings
//

import Foundation

enum L10n {
    enum About {
        static var appName: String { NSLocalizedString("about.appName", comment: "") }
        static var appSubtitle: String { NSLocalizedString("about.appSubtitle", comment: "") }
        static var dataSources: String { NSLocalizedString("about.dataSources", comment: "") }
        static var featureActorfilter: String { NSLocalizedString("about.feature.actorFilter", comment: "") }
        static var featureBondpicker: String { NSLocalizedString("about.feature.bondPicker", comment: "") }
        static var featureCustompicker: String { NSLocalizedString("about.feature.customPicker", comment: "") }
        static var featureDadmode: String { NSLocalizedString("about.feature.dadMode", comment: "") }
        static var featureLanguages: String { NSLocalizedString("about.feature.languages", comment: "") }
        static var features: String { NSLocalizedString("about.features", comment: "") }
        static var legal: String { NSLocalizedString("about.legal", comment: "") }
        static var legalDisclaimer: String { NSLocalizedString("about.legal.disclaimer", comment: "") }
        static var legalNoncommercial: String { NSLocalizedString("about.legal.nonCommercial", comment: "") }
        static var movieData: String { NSLocalizedString("about.movieData", comment: "") }
        static var title: String { NSLocalizedString("about.title", comment: "") }
        static var tmdbAttribution: String { NSLocalizedString("about.tmdb.attribution", comment: "") }
        static var tmdbDisclaimer: String { NSLocalizedString("about.tmdb.disclaimer", comment: "") }
        static var tmdbVisit: String { NSLocalizedString("about.tmdb.visit", comment: "") }
    }

    enum Accessibility {
        static var pickerButtonHint: String { NSLocalizedString("accessibility.pickerButton.hint", comment: "") }
        static var pickerButtonLabel: String { NSLocalizedString("accessibility.pickerButton.label", comment: "") }
    }

    enum Button {
        static var bondPicker: String { NSLocalizedString("button.bondPicker", comment: "") }
        static var moviePicker: String { NSLocalizedString("button.moviePicker", comment: "") }
    }

    enum Common {
        static var close: String { NSLocalizedString("common.close", comment: "") }
        static var done: String { NSLocalizedString("common.done", comment: "") }
        static var back: String { NSLocalizedString("common.back", comment: "") }
        static var next: String { NSLocalizedString("common.next", comment: "") }
        static var getStarted: String { NSLocalizedString("common.getStarted", comment: "") }
    }

    enum Empty {
        static var noMovies: String { NSLocalizedString("empty.noMovies", comment: "") }
        static var tryDifferent: String { NSLocalizedString("empty.tryDifferent", comment: "") }
    }

    enum Error {
        static var noCustomMovie: String { NSLocalizedString("error.noCustomMovie", comment: "") }
        static var noMoviesForActor: String { NSLocalizedString("error.noMoviesForActor", comment: "") }
        static func noMoviesFound(for value: String) -> String {
            String(format: NSLocalizedString("error.noMoviesFound", comment: ""), value)
        }
        static var unableToSelect: String { NSLocalizedString("error.unableToSelect", comment: "") }
    }

    enum Filter {
        static var allActors: String { NSLocalizedString("filter.allActors", comment: "") }
        static var label: String { NSLocalizedString("filter.label", comment: "") }
    }

    enum Instructions {
        static var bondPickerStep1: String { NSLocalizedString("instructions.bondPicker.step1", comment: "") }
        static var bondPickerStep2: String { NSLocalizedString("instructions.bondPicker.step2", comment: "") }
        static var bondPickerStep3: String { NSLocalizedString("instructions.bondPicker.step3", comment: "") }
        static var bondPickerSubtitle: String { NSLocalizedString("instructions.bondPicker.subtitle", comment: "") }
        static var bondPickerTitle: String { NSLocalizedString("instructions.bondPicker.title", comment: "") }
        static var dadModeStep1: String { NSLocalizedString("instructions.dadMode.step1", comment: "") }
        static var dadModeStep2: String { NSLocalizedString("instructions.dadMode.step2", comment: "") }
        static var dadModeStep3: String { NSLocalizedString("instructions.dadMode.step3", comment: "") }
        static var dadModeSubtitle: String { NSLocalizedString("instructions.dadMode.subtitle", comment: "") }
        static var dadModeTitle: String { NSLocalizedString("instructions.dadMode.title", comment: "") }
        static var moviePickerStep1: String { NSLocalizedString("instructions.moviePicker.step1", comment: "") }
        static var moviePickerStep2: String { NSLocalizedString("instructions.moviePicker.step2", comment: "") }
        static var moviePickerStep3: String { NSLocalizedString("instructions.moviePicker.step3", comment: "") }
        static var moviePickerStep4: String { NSLocalizedString("instructions.moviePicker.step4", comment: "") }
        static var moviePickerStep5: String { NSLocalizedString("instructions.moviePicker.step5", comment: "") }
        static var moviePickerSubtitle: String { NSLocalizedString("instructions.moviePicker.subtitle", comment: "") }
        static var moviePickerTitle: String { NSLocalizedString("instructions.moviePicker.title", comment: "") }
        static var title: String { NSLocalizedString("instructions.title", comment: "") }
    }

    enum Menu {
        static var bondPicker: String { NSLocalizedString("menu.bondPicker", comment: "") }
        static var dadMode: String { NSLocalizedString("menu.dadMode", comment: "") }
        static var instructions: String { NSLocalizedString("menu.instructions", comment: "") }
        static var moviePicker: String { NSLocalizedString("menu.moviePicker", comment: "") }
        static var title: String { NSLocalizedString("menu.title", comment: "") }
    }

    enum Mode {
        static var bondPickerDescription: String { NSLocalizedString("mode.bondPicker.description", comment: "") }
        static var moviePickerDescription: String { NSLocalizedString("mode.moviePicker.description", comment: "") }
    }

    enum Search {
        static var currentSelection: String { NSLocalizedString("search.currentSelection", comment: "") }
        static var noResults: String { NSLocalizedString("search.noResults", comment: "") }
        static var placeholder: String { NSLocalizedString("search.placeholder", comment: "") }
        static var prankHint: String { NSLocalizedString("search.prankHint", comment: "") }
        static var searchAny: String { NSLocalizedString("search.searchAny", comment: "") }
        static var searching: String { NSLocalizedString("search.searching", comment: "") }
        static var title: String { NSLocalizedString("search.title", comment: "") }
        static var tryDifferent: String { NSLocalizedString("search.tryDifferent", comment: "") }
    }

}
