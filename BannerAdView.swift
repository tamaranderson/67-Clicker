import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
        // Replace with your actual AdMob banner ad unit ID
        // Test ID: "ca-app-pub-3940256099942544/2934735716"
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootViewController
        }
        
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

// MARK: - Interstitial Ad Manager (Optional - for full screen ads)
class InterstitialAdManager: NSObject, ObservableObject {
    @Published var interstitialAd: GADInterstitialAd?
    
    override init() {
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial() {
        // Replace with your actual AdMob interstitial ad unit ID
        // Test ID: "ca-app-pub-3940256099942544/4411468910"
        let adUnitID = "ca-app-pub-3940256099942544/4411468910"
        
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    func showInterstitial() {
        guard let interstitialAd = interstitialAd else {
            print("Interstitial ad not ready")
            return
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            interstitialAd.present(fromRootViewController: rootViewController)
        }
    }
}

extension InterstitialAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Load the next interstitial ad
        loadInterstitial()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present interstitial ad: \(error.localizedDescription)")
        loadInterstitial()
    }
}
