import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: geometry.size.height * 0.02) {
                    // Header with settings button
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gear")
                                .font(.system(size: geometry.size.height * 0.03))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    
                    // Title
                    Text("67 Clicker")
                        .font(.system(size: geometry.size.height * 0.05, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                    
                    // Stats at top
                    HStack(spacing: geometry.size.width * 0.05) {
                        StatView(
                            label: "Total Taps",
                            value: "\(gameManager.totalTaps)",
                            width: geometry.size.width * 0.4
                        )
                        
                        StatView(
                            label: "Skibidi Rate",
                            value: gameManager.successRateString,
                            width: geometry.size.width * 0.4
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Score display
                    Text("\(gameManager.score)")
                        .font(.system(size: geometry.size.height * 0.1, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 3, y: 3)
                        .scaleEffect(gameManager.scoreScale)
                        .animation(.spring(response: 0.3), value: gameManager.scoreScale)
                    
                    Spacer()
                    
                    // Tap area
                    TapAreaView(gameManager: gameManager)
                        .frame(
                            width: geometry.size.width * 0.9,
                            height: geometry.size.height * 0.35
                        )
                    
                    Spacer()
                    
                    // Instruction
                    Text("Tap with TWO fingers simultaneously to score!")
                        .font(.system(size: geometry.size.height * 0.02))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Ad banner (only if not premium)
                    if !purchaseManager.isPremium {
                        BannerAdView()
                            .frame(height: 50)
                            .background(Color.black.opacity(0.2))
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(purchaseManager)
                    .environmentObject(gameManager)
            }
        }
    }
}

struct StatView: View {
    let label: String
    let value: String
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: width)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PurchaseManager())
    }
}
