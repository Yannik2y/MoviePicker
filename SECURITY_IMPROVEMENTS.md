# Security Improvements — API Key Handling

## Summary
The TMDB API key is no longer hardcoded in source. Clean clones build with a stub; real keys stay out of git.

## Current setup

1. **`MoviePicker/Config.swift`** (committed stub) resolves the key from:
   - Xcode scheme environment variable `TMDB_API_KEY`, or
   - Optional `Secrets.plist` in the app bundle (gitignored)
2. **`Secrets.plist.template`** — copy to `Secrets.plist`, add your key, add the plist to the Xcode target if you use this path. Never commit `Secrets.plist`.
3. **`.gitignore`** excludes `Secrets.plist`.

## If a key was ever committed

1. **Rotate/revoke** that key in the [TMDB API settings](https://www.themoviedb.org/settings/api).
2. Confirm `git log -p -S 'api_key'` / secret scanning no longer finds a live key in docs or Swift sources.
3. If the repo was public with a leaked key, scrub history (`git filter-repo`) after rotation.

## Recommendations for production

1. Environment / CI injection of secrets
2. Server-side proxy so the key never ships in the binary
3. Avoid pasting real keys into markdown “before/after” examples

For this personal project, stub Config + local Secrets/env is sufficient when keys are rotated and never committed.
