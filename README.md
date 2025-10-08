# 🎬 007 Film Picker

A SwiftUI iOS app for randomly selecting James Bond movies with three unique modes, including a clever "prank" feature!

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green.svg)

## 🎯 Features

### Three Picker Modes:

1. **🎯 Bond Picker** - Randomly selects James Bond movies
   - Filter by Bond actor (Sean Connery, Roger Moore, etc.)
   - True random selection
   
2. **🎭 Movie Picker** - Custom movie selection (Prank Mode!)
   - Search ANY movie from TMDB database
   - Appears random but always lands on your pre-selected movie
   - Hidden settings gear (triple-tap top-right corner)
   - Perfect for "tricking" your movie-watching partner!
   
3. **🏆 Dad Mode** - Always selects "WM-Halbfinale 2014"
   - Humorous inside joke mode
   - Always lands on 2014 World Cup Semi-Final

### Additional Features:
- ✨ Smooth scrolling animations with haptic feedback
- 🎨 Beautiful dark theme UI
- 🌍 Full English and German localization
- 🖼️ Movie posters from TMDB
- 📱 Actor filtering
- ⚙️ Persistent settings

## 🚀 Setup

### Prerequisites
- Xcode 14.0+
- iOS 15.0+
- TMDB API Key (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MoviePicker.git
   cd MoviePicker
   ```

2. **Get your TMDB API Key**
   - Go to [TMDB](https://www.themoviedb.org/)
   - Create a free account
   - Navigate to Settings → API
   - Request an API key (Developer)
   - Copy your API Key (v3 auth)

3. **Configure API Key**
   ```bash
   # Copy the template
   cp MoviePicker/Config.swift.template MoviePicker/Config.swift
   ```
   
   Open `MoviePicker/Config.swift` and replace `YOUR_API_KEY_HERE` with your actual API key:
   ```swift
   enum Config {
       static let tmdbAPIKey = "your_actual_api_key_here"
   }
   ```

4. **Open in Xcode**
   ```bash
   open MoviePicker.xcodeproj
   ```

5. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd + R`

## 🔒 Security Note

**Important:** The `Config.swift` file is excluded from Git for security reasons. Never commit your API keys to version control!

The `.gitignore` file automatically excludes:
- `MoviePicker/Config.swift`
- All user data (`xcuserdata/`)

## 🏗️ Architecture

### MVVM Pattern
```
Views → ViewModels → Services → Models
```

### Key Components:

**ViewModels:**
- `PickerViewModel` - Random Bond movie selection
- `DadModeViewModel` - Always WM-Halbfinale 2014
- `CustomPickerViewModel` - Custom movie selection

**Services:**
- `MovieService` - Movie data management
- `TMDBService` - TMDB API integration
- `CustomMovieStorage` - Persistent storage
- `HapticManager` - Haptic feedback

**Views:**
- `SharedMoviePickerView` - Reusable picker UI
- `MovieScrollingView` - Animation engine
- `MovieSearchView` - TMDB search interface

## 📁 Project Structure

```
MoviePicker/
├── Models/
│   ├── JamesBondMovie.swift      # Movie data model
│   ├── BondActor.swift            # Actor enum
│   └── CustomMovieStorage.swift   # Persistence
├── ViewModels/
│   ├── PickerViewModel.swift
│   ├── DadModeViewModel.swift
│   └── CustomPickerViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── SharedMoviePickerView.swift
│   ├── MovieScrollingView.swift
│   └── ...
├── Services/
│   ├── MovieService.swift
│   ├── TMDBService.swift
│   └── HapticManager.swift
├── Constants/
│   ├── AppConstants.swift
│   └── L10n.swift                 # Auto-generated localization
├── Localization/
│   ├── en.lproj/
│   │   └── Localizable.strings
│   └── de.lproj/
│       └── Localizable.strings
├── Config.swift                   # API keys (not in Git)
└── Config.swift.template          # Template for setup
```

## 🌍 Localization

The app supports English and German with type-safe localization:

```swift
// Usage
Text(L10n.Menu.title)  // Compile-time safe!
```

## 🧪 Testing

Run tests:
```bash
# Unit Tests
Cmd + U

# Or via command line
xcodebuild test -scheme MoviePicker -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🎨 UI/UX Features

- **Smooth Animations:** Spring physics with 6-step scrolling
- **Haptic Feedback:** Multi-level haptics (light/medium/heavy)
- **Error Handling:** Auto-dismissing error messages (4 sec)
- **Empty States:** Graceful handling of edge cases
- **Loading States:** Progress indicators for API calls
- **Dark Theme:** Consistent Bond-themed aesthetic

## 📱 How to Use

### Bond Picker Mode:
1. Open menu (☰)
2. Select "Bond Picker"
3. Optionally filter by actor
4. Tap "Bond Picker" button
5. Enjoy your randomly selected Bond movie!

### Movie Picker Mode (Prank):
1. Open menu (☰)
2. Select "Movie Picker"
3. **Triple-tap top-right corner** to reveal settings
4. Tap gear icon (⚙️)
5. Search for any movie
6. Select your movie
7. Tap "Movie Picker" - it always lands on your choice! 😏

### Dad Mode:
1. Open menu (☰)
2. Select "Dad Mode"
3. Tap "Bond Picker" button
4. Always lands on "WM-Halbfinale 2014" 🏆

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is for personal use. All James Bond movie titles and actor names are used for informational purposes only.

### TMDB Attribution

This product uses the TMDB API but is not endorsed or certified by TMDB.

Movie poster images and data provided by [The Movie Database (TMDB)](https://www.themoviedb.org).

## ⚖️ Legal Notice

This app is not affiliated with Eon Productions, MGM, or the James Bond franchise. 

**Non-Commercial Use:** This app is for personal use only and does not generate revenue. TMDB API usage is covered under their free developer license.

## 📞 Support

For setup help or bug reports, see [CUSTOM_PICKER_SETUP.md](CUSTOM_PICKER_SETUP.md) for detailed instructions.

## 🙏 Acknowledgments

- [TMDB](https://www.themoviedb.org) for movie data and posters
- James Bond franchise for the inspiration
- All Bond actors for the amazing movies

---

Made with ❤️ and SwiftUI


