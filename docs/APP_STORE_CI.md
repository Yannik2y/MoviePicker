# App Store Connect CI

This repository ships builds to App Store Connect and can submit them for App Review via **GitHub Actions + Fastlane**. You only need a one-time credential setup.

## What is automated

After secrets are configured:

1. Archive the `MoviePicker` scheme (Release / app-store)
2. Sign with Automatic signing + App Store Connect API key (`-allowProvisioningUpdates`)
3. Upload the IPA to the existing App Store Connect app (`com.PeterPaul.007FilmPicker`)
4. Optionally **Submit for Review** (default on)

Metadata and screenshots are **not** overwritten (`skip_metadata` / `skip_screenshots`).

## One-time setup

### 1. Create an App Store Connect API key

1. Open [App Store Connect → Users and Access → Integrations → App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api)
2. Click **Generate API Key** (or use an existing key)
3. Name: e.g. `MoviePicker CI`
4. Access: **App Manager** or **Admin**
5. Download the `.p8` file once (Apple will not show it again)
6. Note:
   - **Issuer ID** (top of the API keys page)
   - **Key ID**
   - Contents of `AuthKey_XXXXXX.p8`

### 2. Add GitHub repository secrets

Repo → **Settings → Secrets and variables → Actions → New repository secret**:

| Secret name | Value |
|-------------|--------|
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID (e.g. `AB12CD34EF`) |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer UUID |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | Full `.p8` PEM text **or** base64 of the file |
| `TMDB_API_KEY` | Your TMDB v3 API key (injected into `Config.swift` at build time) |

For `APP_STORE_CONNECT_API_KEY_CONTENT`, paste either:

```text
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

or the base64 encoding of that file (`base64 -i AuthKey_XXX.p8 | pbcopy` on macOS).

### 3. Confirm Apple agreements

In App Store Connect, accept any pending **Paid Apps** / **Free Apps** agreements and ensure banking/tax are complete if required for your account. CI cannot accept legal agreements for you.

## How to ship

### Option A — Manual (recommended)

1. Open the repo on GitHub → **Actions** → **Release to App Store**
2. **Run workflow**
3. **TestFlight only:** leave **Submit for App Review** unchecked (default). The IPA uploads to App Store Connect; after processing, enable it under TestFlight (Internal and/or External).
4. **App Review:** check **Submit for App Review** when you intend a full store submission
5. Watch the macOS job; on success the build appears in App Store Connect

CI sets `CURRENT_PROJECT_VERSION` from `BUILD_NUMBER` (`github.run_number` plus 2, computed in a shell step) so the first release run is build **3** (aligned with the Xcode project).

### Option B — Git tag

```bash
git tag v1.1.3
git push origin v1.1.3
```

Tag pushes matching `v*` always run the release lane with **submit for review enabled**.

## Build numbers

CI sets `CURRENT_PROJECT_VERSION` from `github.run_number` so each workflow run gets a unique, increasing build. Marketing version (`MARKETING_VERSION` / `1.1`) stays whatever is in the Xcode project unless you bump it in a commit.

## Local Fastlane (macOS only)

```bash
bundle install
export APP_STORE_CONNECT_API_KEY_ID=...
export APP_STORE_CONNECT_API_ISSUER_ID=...
export APP_STORE_CONNECT_API_KEY_CONTENT="$(cat AuthKey_XXX.p8)"
export BUILD_NUMBER=42
# Optional: upload without review
# export SUBMIT_FOR_REVIEW=false

cp MoviePicker/Config.swift.template MoviePicker/Config.swift
# edit Config.swift with your TMDB key

bundle exec fastlane release
# or: bundle exec fastlane build_only
```

## Troubleshooting

| Symptom | Likely fix |
|---------|------------|
| Missing secret errors | Add all four secrets listed above |
| Code signing / provisioning failures | Ensure the API key is App Manager+, team `7PAQG44S9V` owns the App ID, and Automatic signing is enabled in the project |
| “Build already exists” | Wait for a new workflow run (higher `run_number`) or bump `BUILD_NUMBER` |
| Submit fails on incomplete metadata | Finish listing/age rating/export compliance in ASC; CI does not rewrite metadata |
| Review rejection | Fix in ASC or the app, then re-run the workflow |

## Security

- Never commit `AuthKey_*.p8`, `Config.swift`, or certificates
- Rotate the ASC API key if it leaks; revoke the old key in App Store Connect
- Prefer repository secrets (or GitHub Environments with protection rules) over org-wide secrets unless intentional
