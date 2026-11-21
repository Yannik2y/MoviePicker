# Target module layout

The overhaul introduces this folder layout. New architecture files live at the `MoviePicker/` root for Xcode group compatibility; migrate with `git mv` into these folders in a follow-up PR if desired:

```text
MoviePicker/
  App/           BondPickerApp, MoviePickerApp, AppDependencies, Theme
  Features/
    Picker/      Shared stage, mode VMs/views, scrolling, poster card
    Search/      MovieSearchView
    History/     HistoryView, MovieHistory
    Onboarding/  OnboardingView
    About/       AboutView, InstructionsView
  Domain/        Movie, BondActor, PickerMode, CurrentView
  Data/
    TMDB/        TMDBClient, TMDBService, Config
    Catalog/     MovieService, JamesBondMovie
    Persistence/ CustomMovieStorage, History file store
    Images/      PosterImageCache, TMDBPosterImage
```

Composition root: `BondPickerApp` → `AppDependencies` → feature views via `Environment(\.appDependencies)`.
