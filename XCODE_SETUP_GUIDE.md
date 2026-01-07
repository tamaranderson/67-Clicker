# 67 Clicker - Complete Xcode Project Setup Guide

This guide will walk you through setting up the Xcode project from scratch.

## 📁 Complete Project Structure

```
SixSevenClicker/
├── SixSevenClicker.xcodeproj          (Created by Xcode)
├── SixSevenClicker.xcworkspace        (Created after pod install)
├── Podfile                            (Provided - CocoaPods config)
├── Pods/                              (Created after pod install)
└── SixSevenClicker/
    ├── App/
    │   └── SixSevenClickerApp.swift   (Provided - App entry point)
    ├── Views/
    │   ├── ContentView.swift          (Provided - Main game view)
    │   ├── SettingsView.swift         (Provided - Settings screen)
    │   └── BannerAdView.swift         (Provided - Ad integration)
    ├── Managers/
    │   ├── GameManager.swift          (Provided - Game logic)
    │   └── PurchaseManager.swift      (Provided - IAP logic)
    ├── Assets.xcassets/
    │   ├── AppIcon.appiconset/       (Add your app icon)
    │   ├── special1.imageset/         (Add your special images)
    │   ├── special2.imageset/
    │   ├── special3.imageset/
    │   ├── special4.imageset/
    │   └── special5.imageset/
    └── Info.plist                     (Provided - App configuration)
```

## 🚀 Step-by-Step Setup

### Step 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Click "Next"
5. Fill in:
   - **Product Name**: `SixSevenClicker`
   - **Team**: Select your Apple Developer team
   - **Organization Identifier**: `com.yourcompany` (use your actual reverse domain)
   - **Bundle Identifier**: Will be `com.yourcompany.SixSevenClicker`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
   - **Include Tests**: Uncheck both boxes
6. Click "Next" and choose where to save
7. Click "Create"

### Step 2: Organize Your Project Files

1. **Delete the default `ContentView.swift`** that Xcode created (we'll replace it)
2. **Create folder groups** in Xcode:
   - Right-click on "SixSevenClicker" folder in Project Navigator
   - New Group → Name it "App"
   - New Group → Name it "Views"
   - New Group → Name it "Managers"
3. **Move files into groups**:
   - Drag `SixSevenClickerApp.swift` into "App" group
   - Keep `Assets.xcassets` and `Info.plist` at root level

### Step 3: Add All Swift Files

Add each of these files to your project:

1. **In "App" group**:
   - `SixSevenClickerApp.swift` (provided)

2. **In "Views" group**:
   - `ContentView.swift` (provided)
   - `SettingsView.swift` (provided)
   - `BannerAdView.swift` (provided)

3. **In "Managers" group**:
   - `GameManager.swift` (provided)
   - `PurchaseManager.swift` (provided)

**How to add files:**
- Drag files from Finder into Xcode, OR
- Right-click group → Add Files to "SixSevenClicker" → Select file
- Make sure "Copy items if needed" is CHECKED
- Target membership: "SixSevenClicker" should be CHECKED

### Step 4: Replace Info.plist

1. Delete the existing `Info.plist` in Xcode
2. Drag the provided `Info.plist` into your project
3. Make sure it's at the root level (not in a group)
4. Make sure "Copy items if needed" is checked

### Step 5: Install CocoaPods Dependencies

1. **Close Xcode completely**
2. Open Terminal
3. Navigate to your project folder:
   ```bash
   cd /path/to/SixSevenClicker
   ```
4. Create the `Podfile` if not already there:
   ```bash
   # Copy the provided Podfile into this directory
   ```
5. Install CocoaPods (if you haven't already):
   ```bash
   sudo gem install cocoapods
   ```
6. Install dependencies:
   ```bash
   pod install
   ```
7. **IMPORTANT**: From now on, always open `SixSevenClicker.xcworkspace`, NOT `SixSevenClicker.xcodeproj`

### Step 6: Configure App Settings

1. Open `SixSevenClicker.xcworkspace` in Xcode
2. Select your project in Project Navigator (top level)
3. Select "SixSevenClicker" under TARGETS
4. Go to "Signing & Capabilities" tab:
   - Check "Automatically manage signing"
   - Select your Team
   - Bundle Identifier should be: `com.yourcompany.SixSevenClicker`

5. Go to "General" tab:
   - **Display Name**: `67 Clicker`
   - **Bundle Identifier**: `com.yourcompany.SixSevenClicker`
   - **Version**: `1.0`
   - **Build**: `1`
   - **Deployment Target**: iOS 14.0
   - **iPhone Orientation**: Portrait only

### Step 7: Add Special Images to Assets

1. Click on `Assets.xcassets` in Project Navigator
2. Click the `+` button at the bottom
3. Select "Image Set"
4. Name it `special1`
5. Drag your image into the 1x slot (or 2x, or 3x depending on your image size)
6. Repeat for `special2`, `special3`, `special4`, `special5`

**Image requirements:**
- Supported formats: PNG, JPG
- Recommended size: 1024x1024px
- For best results, provide @1x, @2x, and @3x versions

### Step 8: Configure AdMob

#### A. Get your AdMob Account Ready
1. Go to https://admob.google.com
2. Create an account if you don't have one
3. Click "Apps" → "Add App"
4. Add your app (can say "not published yet")
5. Note your **App ID** (looks like: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`)

#### B. Create Ad Units
1. In AdMob, go to your app
2. Click "Ad units" → "Add Ad Unit"
3. Select "Banner"
4. Name it "Main Banner"
5. Note your **Banner Ad Unit ID** (looks like: `ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY`)

#### C. Update Your Code
1. Open `Info.plist` in Xcode
2. Find `GADApplicationIdentifier`
3. Replace the test ID with your **App ID** from step A
4. Open `BannerAdView.swift`
5. Find this line:
   ```swift
   banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
   ```
6. Replace with your **Banner Ad Unit ID** from step B

**NOTE**: Keep the test IDs during development! Only use real IDs for production.

### Step 9: Configure In-App Purchases

#### A. In App Store Connect
1. Go to https://appstoreconnect.apple.com
2. Click "My Apps" → "+" → "New App"
3. Fill in app details
4. Go to "Features" → "In-App Purchases"
5. Click "+" to create new
6. Select "Non-Consumable"
7. Fill in:
   - **Product ID**: `com.yourcompany.SixSevenClicker.premium`
   - **Reference Name**: Remove Ads
   - **Price**: Choose your price tier
8. Click "Save"

#### B. Update Your Code
1. Open `PurchaseManager.swift`
2. Find this line:
   ```swift
   private let productID = "com.yourcompany.67clicker.premium"
   ```
3. Replace with your **Product ID** from step A.7

### Step 10: Build and Test

1. Select your device or simulator from the scheme menu (top left)
2. Click the Play button (⌘+R) or Product → Run
3. The app should compile and run!

**If you get errors:**
- Make sure you opened the `.xcworkspace` file, not `.xcodeproj`
- Make sure all files have target membership checked
- Clean build folder: Shift+⌘+K
- Delete derived data: Xcode → Preferences → Locations → Click arrow next to Derived Data → Delete folder

## 🧪 Testing

### Test the Game
- Tap with two fingers simultaneously → score should increase
- Tap with one finger or three → no score
- Reach score 67, 167, 267, etc. → special image should appear

### Test Ads (Development)
- Ads should show at bottom of left panel
- Using test IDs, you'll see "Test Ad" banners
- These are safe to click during development

### Test In-App Purchase (Sandbox)
1. In Xcode: Product → Scheme → Edit Scheme
2. Run → Options → StoreKit Configuration
3. Create new StoreKit Configuration file
4. Add your product with same ID
5. Run app and test purchase flow

## 📱 Deploying to Physical Device

1. Connect your iPhone/iPad via USB
2. Select it from the device menu in Xcode
3. Click Run
4. On device, go to Settings → General → VPN & Device Management
5. Trust your developer certificate
6. App should now run on device

## 🚀 Submitting to App Store

### Before Submitting

1. **Replace Test Ad IDs** with production IDs in `BannerAdView.swift`
2. **Create App Icon**:
   - Need 1024x1024px PNG
   - Drag into Assets.xcassets → AppIcon
3. **Add Screenshots** in App Store Connect:
   - 6.5" iPhone (1284 x 2778px) - Required
   - 12.9" iPad Pro (2048 x 2732px) - If supporting iPad
4. **Update Info.plist**:
   - Check all permissions are listed
5. **Test thoroughly** on multiple devices

### Archive and Upload

1. Select "Any iOS Device (arm64)" from device menu
2. Product → Archive
3. Wait for archive to complete
4. Organizer window opens
5. Select your archive
6. Click "Distribute App"
7. Choose "App Store Connect"
8. Click "Upload"
9. Wait for processing (can take 30 min - 2 hours)
10. Go to App Store Connect to submit for review

### App Store Connect Setup

1. Fill in app metadata:
   - Name: 67 Clicker
   - Subtitle: Two-Finger Tap Challenge
   - Description: (write engaging description)
   - Keywords: clicker, game, tap, challenge
   - Category: Games
2. Add screenshots
3. Set price
4. Enable in-app purchase
5. Submit for review

## ❓ Common Issues

### "No such module 'GoogleMobileAds'"
- Make sure you ran `pod install`
- Make sure you opened `.xcworkspace`, not `.xcodeproj`
- Try: `pod deintegrate` then `pod install`

### Ads not showing
- Check internet connection
- Verify AdMob account is active
- Test ads may take a few seconds to load
- Check console for error messages

### In-App Purchase not working
- Make sure you're using a sandbox test account
- Check product ID matches exactly
- Verify agreements are signed in App Store Connect
- Device must be signed out of real Apple ID, then use sandbox account

### Build errors
- Clean build: Shift+⌘+K
- Delete derived data
- Restart Xcode
- Make sure iOS deployment target is 14.0 or higher

### Image not found
- Make sure images are in Assets.xcassets
- Image names in code must match asset names exactly
- Image names are case-sensitive

## 📚 File Descriptions

- **SixSevenClickerApp.swift**: App entry point, initializes managers
- **ContentView.swift**: Main game UI with left/right panels
- **SettingsView.swift**: Settings screen with IAP and stats
- **BannerAdView.swift**: AdMob banner ad integration
- **GameManager.swift**: Game logic, scoring, 67 detection
- **PurchaseManager.swift**: StoreKit IAP implementation
- **Info.plist**: App configuration including AdMob app ID
- **Podfile**: CocoaPods dependencies (Google Ads SDK)

## 🎯 Next Steps

1. Add more special images (special6, special7, etc.)
2. Customize colors and styling
3. Add sound effects
4. Add achievements
5. Add leaderboards with Game Center
6. Add more game modes

Good luck with your app! 🎮
