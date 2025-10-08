# Custom Picker Mode - Setup Guide 🎬

## What Was Built

A complete **Custom Picker Mode** that lets you trick your movie-watching partner! 😏

### Features:
- ✅ Search **ANY movie** from TMDB's massive database
- ✅ Real movie posters automatically downloaded
- ✅ Cast information fetched automatically
- ✅ Bond movies scroll, then lands on YOUR chosen movie
- ✅ Settings gear icon to change selection anytime
- ✅ Beautiful search UI with live results
- ✅ Saved selection persists between app launches

---

## Setup Instructions

### Step 1: Get Your TMDB API Key (Free!)

1. Go to: https://www.themoviedb.org/
2. Click **"Join TMDB"** and create a free account
3. Verify your email
4. Go to: https://www.themoviedb.org/settings/api
5. Click **"Create"** under "Request an API Key"
6. Choose **"Developer"**
7. Accept the terms
8. Fill out the form (you can use dummy data):
   - Application Name: `MoviePicker`
   - Application URL: `https://example.com`
   - Application Summary: `Personal movie picker app`
9. Click **Submit**
10. Copy your **API Key (v3 auth)**

### Step 2: Add API Key to Your App

1. Open Xcode
2. Navigate to: `MoviePicker/Config.swift.template`
3. Copy the file and rename it to `Config.swift`
4. Open `Config.swift` and find:
   ```swift
   static let tmdbAPIKey = "YOUR_API_KEY_HERE"
   ```
5. Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```swift
   static let tmdbAPIKey = "abc123def456..." // Your actual key
   ```
6. Save the file

**Note:** `Config.swift` is excluded from Git for security, so your API key stays private!

### Step 3: Build & Run! 🚀

That's it! The app is ready to use.

---

## How to Use

### Setting Up Your Custom Movie:

1. **Open the app**
2. **Tap the menu** (☰ icon)
3. **Select "Custom Picker"** (target icon 🎯)
4. **Tap the settings gear** (⚙️) in the top-right
5. **Search for any movie**:
   - Type: "The Notebook"
   - Or: "Mamma Mia!"
   - Or: "Titanic"
   - Or literally anything!
6. **Tap a result** to select it
7. **Done!** Your selection is saved

### Using Custom Picker Mode:

1. Make sure you're in **Custom Picker mode** (check the menu)
2. Tap **"Bond Picker"** button
3. Watch Bond movies scroll...
4. **BOOM!** Lands on your custom movie 😄
5. Your partner thinks it's random! 🎭

---

## Files Created

### Core Services:
- `TMDBService.swift` - API integration with TMDB
- `CustomMovieStorage.swift` - Saves your selected movie
- `CustomPickerViewModel.swift` - Business logic

### UI Components:
- `MovieSearchView.swift` - Search interface
- `CustomPickerView.swift` - Main custom picker view
- `CustomMovieView.swift` - Displays custom movies with posters

### Updated Files:
- `CurrentView.swift` - Added customPickerView case
- `MenuView.swift` - Added Custom Picker menu option
- `MoviePickerApp.swift` - Wired up custom picker
- `MovieScrollingView.swift` - Handles custom movie display

---

## Troubleshooting

### "TMDB API key not configured" error:
- Make sure you created `Config.swift` from the template
- Check that you replaced `YOUR_API_KEY_HERE` with your actual API key in `Config.swift`
- Build the project again (Cmd+B)

### No search results:
- Check your internet connection
- Verify your API key is correct
- Try a more common movie name

### Poster not showing:
- This is normal for some older/obscure movies
- A placeholder with the movie title will show instead
- The trick still works perfectly!

---

## The Perfect Prank Setup 🎭

**Scenario:**
1. Partner: "Let's watch a Bond movie!"
2. You: "Sure! Let me use my random picker..."
3. *Sets Custom Picker to "Legally Blonde" beforehand*
4. *Taps Bond Picker button*
5. *Bond movies scroll dramatically*
6. *Lands on Legally Blonde*
7. Partner: "Wait... what?! 😂"

---

## Technical Details

### Data Flow:
```
User Search → TMDB API → Results List → User Selection
                ↓
        Download Poster Image
                ↓
      Save to UserDefaults + Local Storage
                ↓
    Custom Picker Always Targets This Movie
```

### Storage:
- Movie data: `UserDefaults` (title, year, actor, TMDB ID)
- Poster image: Cached as `Data` in UserDefaults
- Persists across app launches

### API Limits:
- TMDB free tier: **40 requests per 10 seconds**
- More than enough for this app!

---

## Privacy Note

All movie data is stored locally on your device. Nothing is sent to any server except TMDB API calls.

---

## Need Help?

If you encounter any issues:
1. Check that your API key is correctly added
2. Verify you have internet connection
3. Try rebuilding the project (Cmd+Shift+K, then Cmd+B)

**Enjoy pranking your movie partners!** 🎬😄

