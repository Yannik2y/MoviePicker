# 007 Film Picker

A SwiftUI iOS app for picking James Bond movies — with Bond Picker as the core experience, plus Movie Picker (custom / host tools) and Dad Mode.

![iOS](https://img.shields.io/badge/iOS%20%2F%20iPadOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5-green.svg)

**Unofficial fan app** — not affiliated with, endorsed by, or licensed by Eon Productions, MGM, Danjaq, or the James Bond franchise.

## Features

### Three picker modes

1. **Bond Picker** (default) — Random James Bond film, optional actor filter
2. **Movie Picker** — Host-selected film that the reveal always lands on (Host tools in the toolbar)
3. **Dad Mode** — Always lands on “WM-Halbfinale 2014”

### Also

- Poster reveal animation with haptics (respects Reduce Motion)
- History, favorites, and stats
- English and German localization
- TMDB posters and custom search
- Native tab / split navigation on iPhone and iPad

## Setup

### Prerequisites

- Xcode 16+ (CI uses Xcode 27.x)
- iOS / iPadOS 17.0+
- TMDB API key (free) for search and remote posters

### Installation

1. Clone the repo and open `MoviePicker.xcodeproj`
2. Configure a TMDB key (never commit a real key):
   - Scheme env: `TMDB_API_KEY`, or
   - `cp MoviePicker/Secrets.plist.template MoviePicker/Secrets.plist` and add the key to the target
3. Build and run on a simulator or device

See [`PRIVACY.md`](PRIVACY.md) for what leaves the device (search queries + poster downloads to TMDB).

## How to use

### Bond Picker

1. Open the **Pick** tab (Bond is the default mode)
2. Optionally filter by actor
3. Tap the picker button

### Movie Picker (host tools)

1. Switch to **Movie Picker** on the Pick tab
2. Open **Host tools** from the toolbar menu
3. Search TMDB and select a film
4. Tap the picker — it always lands on your selection

### Dad Mode

1. Switch to **Dad Mode**
2. Tap the picker — always WM-Halbfinale 2014

## Architecture

Composition root (`BondPickerApp`) injects `AppDependencies` (catalog, TMDB client, history, custom store, image loader). Features use environment / initializer injection rather than reaching into `.shared` singletons from views.

```
MoviePicker/
  App/           BondPickerApp, AppDependencies, Theme, root shell
  Features/      Picker, Search, History, Onboarding, About
  Domain/        Movie, BondActor, PickerMode
  Data/          TMDB client, catalog, persistence, images
```

## Localization

Type-safe keys via `L10n` (en / de).

## Testing

```bash
xcodebuild test -scheme MoviePicker -destination 'platform=iOS Simulator,name=iPhone 16'
```

CI runs build and unit tests on pull requests (see `.github/workflows/ios.yml`).

## App Store / CI

Builds upload via GitHub Actions + Fastlane. See [`docs/APP_STORE_CI.md`](docs/APP_STORE_CI.md).

Historical checklists that may contradict the current app are listed in [`docs/OBSOLETE.md`](docs/OBSOLETE.md).

## Legal / TMDB

This product uses the TMDB API but is not endorsed or certified by TMDB.  
Movie poster images and data provided by [The Movie Database (TMDB)](https://www.themoviedb.org).

## Support

Bug reports: [GitHub Issues](https://github.com/Yannik2y/MoviePicker/issues)
