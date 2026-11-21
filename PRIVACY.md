# Privacy Policy — 007 Film Picker

**Last updated:** November 2026

## Summary

007 Film Picker does **not** track you and does **not** use analytics SDKs.  
It stores a small amount of data **on your device** and talks to **The Movie Database (TMDB)** for movie search and posters.

## Data stored on your device

The app may store locally (via system preferences / files on the device):

- Movie selection history and favorites (optional, created when you pick films)
- Your custom “Movie Picker” selection and its poster image (optional)
- Onboarding completion flag
- Cached Bond poster URLs for faster loading

These local records are **not** uploaded to a server operated by the app author.

## Network: TMDB

The app uses the [TMDB API](https://www.themoviedb.org/) and TMDB image CDN to:

- Search for movies when you type a query in Movie Picker (your search text is sent to TMDB)
- Resolve cast / credits for a selected custom movie
- Load and cache movie poster images
- On first launch (or when the poster cache is empty), look up poster URLs for Bond catalog titles

An API key configured for the build is sent with those requests.  
This product uses the TMDB API but is **not** endorsed or certified by TMDB.

## What we do not do

- No advertising identifiers or third-party analytics
- No account system, sign-in, or cloud sync of history
- No sale of personal data

## Contact

Questions: [GitHub Issues](https://github.com/Yannik2y/MoviePicker/issues)

## Changes

This policy may be updated when app behavior changes. The “Last updated” date above reflects the latest revision.
