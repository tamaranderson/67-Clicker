import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var gameManager: GameManager
    @State private var showResetAlert = false
    @State private var showPurchaseAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "FF6B9D"),  // Bright pink
                        Color(hex: "FFA07A"),  // Light coral
                        Color(hex: "FFD93D"),  // Bright yellow
                        Color(hex: "6BCF7F"),  // Bright green
                        Color(hex: "4D9DE0"),  // Bright blue
                        Color(hex: "BB6BD9")   // Bright purple
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Premium Section
                        if !purchaseManager.isPremium {
                            PremiumCard(purchaseManager: purchaseManager, showPurchaseAlert: $showPurchaseAlert)
                                .padding(.horizontal)
                        } else {
                            PremiumActiveCard()
                                .padding(.horizontal)
                        }
                        
                        // Stats Section
                        StatsCard(gameManager: gameManager)
                            .padding(.horizontal)
                        
                        // Actions Section
                        VStack(spacing: 15) {
                            if !purchaseManager.isPremium {
                                Button(action: {
                                    purchaseManager.restorePurchases()
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Restore Purchases")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                }
                            }
                            
                            Button(action: {
                                showResetAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Reset Stats")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        
                        // App Info
                        VStack(spacing: 5) {
                            Text("67 Clicker")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 30)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .alert("Reset Statistics", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    gameManager.resetStats()
                }
            } message: {
                Text("Are you sure you want to reset all your statistics? This action cannot be undone.")
            }
            .alert("Purchase Complete", isPresented: $showPurchaseAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Thank you for going premium! Ads have been removed.")
            }
        }
    }
}

struct PremiumCard: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var showPurchaseAlert: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "crown.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                Text("Go Premium")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            
            Text("Remove all ads and support development!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            if let product = purchaseManager.products.first {
                Button(action: {
                    purchaseManager.purchasePremium()
                }) {
                    HStack {
                        Text("Purchase")
                        Spacer()
                        Text(product.localizedPrice)
                    }
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .fontWeight(.semibold)
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

struct PremiumActiveCard: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title)
                    .foregroundColor(.green)
                Text("Premium Active")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            
            Text("Thank you for your support!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

struct StatsCard: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Your Statistics")
                .font(.headline)
                .foregroundColor(.white)
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            StatRow(label: "Score", value: "\(gameManager.score)")
            StatRow(label: "Total Taps", value: "\(gameManager.totalTaps)")
            StatRow(label: "Successful Taps", value: "\(gameManager.successfulTaps)")
            StatRow(label: "Best Streak", value: "\(gameManager.bestStreak)")
            StatRow(label: "Skibidi Rate", value: gameManager.successRateString)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.15))
        )
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

// Extension for SKProduct to get localized price
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price) ?? ""
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PurchaseManager())
            .environmentObject(GameManager())
    }
}
