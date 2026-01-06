import SwiftUI

@main
struct SixSevenClickerApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
        }
    }
}
