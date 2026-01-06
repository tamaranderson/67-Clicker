# 67 Clicker - iOS App

A fun two-finger tap game for iOS with ad support and in-app purchases.

## Features

- ✅ Two-finger simultaneous tap detection
- ✅ Real-time statistics (Total Taps, Skibidi Rate)
- ✅ Persistent data storage
- ✅ Haptic feedback
- ✅ AdMob banner ads (free version)
- ✅ In-app purchase to remove ads
- ✅ Fully responsive UI that adapts to all screen sizes
- ✅ Beautiful gradient design

## Requirements

- iOS 14.0+
- Xcode 13.0+
- CocoaPods
- Apple Developer Account (for deploying to device)
- Google AdMob Account (for ads)

## Setup Instructions

### 1. Install Dependencies

First, install CocoaPods if you haven't already:
```bash
sudo gem install cocoapods
```

Navigate to your project directory and install pods:
```bash
cd /path/to/your/project
pod install
```

**IMPORTANT:** After running `pod install`, always open the `.xcworkspace` file, NOT the `.xcodeproj` file.

### 2. Configure AdMob

1. Go to https://admob.google.com/
2. Create a new app
3. Create ad units:
   - Banner ad unit
   - Interstitial ad unit (optional)
4. Replace the test ad unit IDs in `BannerAdView.swift`:
   ```swift
   // Replace test IDs with your actual AdMob IDs
   banner.adUnitID = "YOUR_BANNER_AD_UNIT_ID"
   ```
5. Update the `GADApplicationIdentifier` in `Info.plist` with your AdMob App ID

### 3. Configure In-App Purchases

1. Go to App Store Connect (https://appstoreconnect.apple.com)
2. Create your app
3. Navigate to "Features" → "In-App Purchases"
4. Create a new "Non-Consumable" product:
   - Product ID: `com.yourcompany.67clicker.premium` (or your custom ID)
   - Reference Name: "Remove Ads"
   - Price: Your chosen price
5. Update the product ID in `PurchaseManager.swift`:
   ```swift
   private let productID = "YOUR_PRODUCT_ID"
   ```

### 4. Configure Bundle Identifier

1. Open the project in Xcode
2. Select your project in the Project Navigator
3. Under "Signing & Capabilities", set your Bundle Identifier
4. Example: `com.yourcompany.67clicker`

### 5. Testing

#### Test Ads (Already configured)
The app uses Google AdMob test ad unit IDs by default. These will show test ads during development.

#### Test In-App Purchases
1. In App Store Connect, create sandbox test users
2. Sign out of your Apple ID on your test device
3. Run the app and try to make a purchase
4. Sign in with your sandbox test user when prompted

### 6. Production Deployment

Before releasing to the App Store:

1. **Update Ad Unit IDs**: Replace test ad unit IDs with production IDs
2. **Update Bundle ID**: Ensure it matches your App Store Connect app
3. **App Store Connect Setup**:
   - Configure app metadata
   - Add screenshots
   - Set pricing
   - Enable in-app purchases
4. **Archive and Upload**:
   - Product → Archive
   - Distribute to App Store

## Project Structure

```
SixSevenClicker/
├── SixSevenClickerApp.swift      # App entry point
├── ContentView.swift              # Main game view
├── TapAreaView.swift              # Two-finger tap detection
├── GameManager.swift              # Game state management
├── PurchaseManager.swift          # In-app purchase handling
├── BannerAdView.swift             # AdMob integration
├── SettingsView.swift             # Settings and premium purchase
├── Info.plist                     # App configuration
└── Podfile                        # Dependencies
```

## Key Features Explained

### Two-Finger Tap Detection
Uses a custom `UIGestureRecognizer` to detect exactly 2 simultaneous touches. Single taps or 3+ finger taps don't register as successful.

### Ad Implementation
- Banner ads appear at the bottom of the screen (free version only)
- Ads are automatically hidden when user purchases premium
- Uses Google AdMob SDK

### In-App Purchases
- Uses StoreKit framework
- Non-consumable purchase type (one-time payment)
- Supports purchase restoration
- Premium status persists across app reinstalls

### Data Persistence
- Game statistics saved to UserDefaults
- Premium status saved locally
- Data survives app restarts

## Customization

### Change Colors
Edit the gradient colors in `ContentView.swift`:
```swift
LinearGradient(
    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Adjust Sizes
All UI elements use relative sizing based on screen geometry:
- Title: `geometry.size.height * 0.05`
- Score: `geometry.size.height * 0.1`
- Tap Area: `geometry.size.height * 0.35`

### Add Interstitial Ads
Uncomment and implement the `InterstitialAdManager` in `BannerAdView.swift` to show full-screen ads at specific intervals.

## Troubleshooting

### Pods Not Found
```bash
pod deintegrate
pod install
```

### Ad Not Showing
- Verify internet connection
- Check AdMob account is active
- Confirm ad unit IDs are correct
- Test ads may take a few seconds to load

### In-App Purchase Not Working
- Ensure you're signed in with a sandbox test account
- Verify product ID matches App Store Connect
- Check that agreements are signed in App Store Connect

### Build Errors
- Clean build folder: Shift + Cmd + K
- Delete DerivedData folder
- Ensure you're opening `.xcworkspace` not `.xcodeproj`

## Important Notes

1. **Test IDs**: The app comes with Google AdMob test ad unit IDs. Replace these before production!
2. **Privacy**: Update your Privacy Policy to comply with AdMob and Apple requirements
3. **App Store Review**: Be prepared to demonstrate in-app purchase functionality
4. **IDFA**: If using personalized ads, you'll need to request App Tracking Transparency permission

## License

This is a sample project for educational purposes.

## Support

For questions about:
- AdMob: https://support.google.com/admob
- In-App Purchases: https://developer.apple.com/support/
- StoreKit: https://developer.apple.com/documentation/storekit

## Version History

- **1.0**: Initial release with two-finger tap detection, ads, and IAP support
