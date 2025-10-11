# App Store Publishing Guide for MoviePicker

## Prerequisites ✅
- [x] Apple Developer Account (you have this)
- [x] App icons generated (just completed)
- [x] App functionality complete
- [x] Git repository created

## Step-by-Step Publishing Process

### Step 1: Configure App Settings in Xcode

1. **Open your project in Xcode**
   ```bash
   open MoviePicker.xcodeproj
   ```

2. **Set up App Information**
   - Select your project in the navigator
   - Choose the "MoviePicker" target
   - Go to "General" tab
   - Set the following:
     - **Display Name**: "MoviePicker" (or your preferred name)
     - **Bundle Identifier**: `com.yourname.moviepicker` (must be unique)
     - **Version**: "1.0" (for first release)
     - **Build**: "1" (increment for each build)
     - **Deployment Target**: iOS 15.0 or higher

3. **Configure Signing & Capabilities**
   - Go to "Signing & Capabilities" tab
   - Check "Automatically manage signing"
   - Select your Team (your developer account)
   - Ensure "Release" configuration is selected

### Step 2: App Store Connect Setup

1. **Log into App Store Connect**
   - Go to https://appstoreconnect.apple.com
   - Sign in with your Apple ID

2. **Create New App**
   - Click "My Apps" → "+" → "New App"
   - Fill in:
     - **Platform**: iOS
     - **Name**: "MoviePicker"
     - **Primary Language**: English
     - **Bundle ID**: Select the one you created in Xcode
     - **SKU**: A unique identifier (e.g., "moviepicker-ios")

3. **App Information**
   - **Category**: Entertainment
   - **Content Rights**: Check if you have rights to use content
   - **Age Rating**: Complete the questionnaire

### Step 3: App Store Listing

1. **App Information Tab**
   - **App Name**: "MoviePicker"
   - **Subtitle**: "Random James Bond Movie Selector"
   - **Description**: 
     ```
     Discover your next James Bond adventure! MoviePicker helps you randomly select from the complete collection of Bond films, from Sean Connery to Daniel Craig.
     
     Features:
     • Random Bond movie selection
     • Custom movie picker mode
     • Movie history and favorites
     • TMDB integration for detailed info
     • Optimized for iPhone and iPad
     • Available in English and German
     ```

2. **Keywords**: "bond, james bond, movie, random, picker, entertainment"

3. **Support URL**: Your website or GitHub repository
4. **Marketing URL**: Optional

### Step 4: Screenshots and App Preview

1. **Required Screenshots**
   - iPhone 6.7" Display: 1290 x 2796 pixels
   - iPhone 6.5" Display: 1242 x 2688 pixels
   - iPhone 5.5" Display: 1242 x 2208 pixels
   - iPad Pro (6th Gen) 12.9": 2048 x 2732 pixels
   - iPad Pro (6th Gen) 11": 1668 x 2388 pixels

2. **How to Take Screenshots**
   - Run your app in the iOS Simulator
   - Use Device → Screenshot in Simulator
   - Or use Xcode → Window → Devices and Simulators

### Step 5: Build and Archive

1. **Clean Build Folder**
   - In Xcode: Product → Clean Build Folder (⇧⌘K)

2. **Select Generic iOS Device**
   - In the scheme selector, choose "Any iOS Device (arm64)"

3. **Archive**
   - Product → Archive (⌘⇧B)
   - Wait for the archive to complete

### Step 6: Upload to App Store Connect

1. **Organizer Window**
   - After archiving, Xcode opens Organizer
   - Select your archive
   - Click "Distribute App"

2. **Distribution Method**
   - Choose "App Store Connect"
   - Click "Next"

3. **Distribution Options**
   - Choose "Upload"
   - Click "Next"

4. **App Store Connect Distribution Options**
   - Check "Upload your app's symbols"
   - Check "Manage Version and Build Number"
   - Click "Next"

5. **Re-sign**
   - Choose "Automatically manage signing"
   - Click "Next"

6. **Review and Upload**
   - Review the summary
   - Click "Upload"
   - Wait for upload to complete

### Step 7: Submit for Review

1. **Back to App Store Connect**
   - Go to your app in App Store Connect
   - The build should appear in "Build" section

2. **Select Build**
   - In "iOS App" tab, scroll to "Build" section
   - Click "+" next to Build
   - Select your uploaded build

3. **Complete App Review Information**
   - **Contact Information**: Your contact details
   - **Demo Account**: If needed
   - **Notes**: Any special instructions for reviewers

4. **Submit for Review**
   - Click "Submit for Review"
   - Confirm submission

### Step 8: Review Process

- **Typical Timeline**: 24-48 hours
- **Status Updates**: Check App Store Connect regularly
- **Possible Outcomes**:
  - ✅ Approved
  - ❌ Rejected (with feedback)
  - ⏳ In Review
  - 📝 Pending Developer Release

### Step 9: Release

1. **Automatic Release**: App goes live immediately after approval
2. **Manual Release**: You control when it goes live
3. **Phased Release**: Gradual rollout to users

## Important Notes

### Before Submitting:
- [ ] Test on multiple devices
- [ ] Test all features thoroughly
- [ ] Ensure app works offline
- [ ] Check for crashes
- [ ] Verify all text is properly localized
- [ ] Test with different iOS versions

### Common Rejection Reasons:
- App crashes
- Missing functionality described in description
- Poor user experience
- Violation of App Store guidelines
- Missing required metadata

### After Approval:
- Monitor crash reports
- Respond to user reviews
- Plan updates and new features
- Track analytics

## Quick Checklist

- [ ] App configured in Xcode
- [ ] App Store Connect app created
- [ ] Screenshots prepared
- [ ] App description written
- [ ] Build archived
- [ ] Uploaded to App Store Connect
- [ ] Submitted for review
- [ ] App approved and released

## Support Resources

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Estimated Timeline**: 1-2 weeks from submission to approval
**Cost**: $99/year for Apple Developer Program (you already have this)
