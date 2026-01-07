import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left Panel - Stats
                LeftPanelView(gameManager: gameManager, purchaseManager: purchaseManager, showSettings: $showSettings)
                    .frame(width: geometry.size.width * 0.35)
                
                // Right Panel - Clicker
                RightPanelView(gameManager: gameManager)
            }
            .background(
                LinearGradient(
                    colors: [Color(hex: "4a2511"), Color(hex: "2d1508")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(purchaseManager)
                    .environmentObject(gameManager)
            }
        }
    }
}

struct LeftPanelView: View {
    @ObservedObject var gameManager: GameManager
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var showSettings: Bool
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "2b1a0a"), Color(hex: "1a0f06")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    // Settings button
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gear")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "FFD700"))
                                .padding()
                        }
                    }
                    
                    // Header
                    VStack {
                        Text("67 Clicker")
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .foregroundColor(Color(hex: "FFD700"))
                            .shadow(color: Color(hex: "8B4513"), radius: 0, x: 3, y: 3)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "8B4513").opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "8B4513"), lineWidth: 2)
                            )
                    )
                    .padding(.horizontal)
                    
                    // Score Section
                    VStack(spacing: 10) {
                        Text("67 pairs tapped")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "DEB887"))
                        
                        Text("\(gameManager.score)")
                            .font(.system(size: 60, weight: .bold, design: .default))
                            .foregroundColor(Color(hex: "FFD700"))
                            .shadow(color: Color(hex: "8B4513"), radius: 0, x: 2, y: 2)
                            .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 10)
                            .scaleEffect(gameManager.scoreScale)
                            .animation(.spring(response: 0.3), value: gameManager.scoreScale)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "FFD700"), lineWidth: 3)
                            )
                            .shadow(color: Color(hex: "FFD700").opacity(0.3), radius: 20)
                    )
                    .padding(.horizontal)
                    
                    // Stats Section
                    VStack(spacing: 15) {
                        Text("📊 Statistics")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "FFD700"))
                            .frame(maxWidth: .infinity)
                        
                        StatItemView(label: "Total Taps", value: "\(gameManager.totalTaps)")
                        StatItemView(label: "Skibidi Rate", value: gameManager.successRateString)
                        StatItemView(label: "Best Streak", value: "\(gameManager.bestStreak)")
                        StatItemView(label: "Special 67s Hit", value: "\(gameManager.special67Count)")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "8B4513"), lineWidth: 2)
                            )
                    )
                    .padding(.horizontal)
                    
                    // Ad banner (only if not premium)
                    if !purchaseManager.isPremium {
                        BannerAdView()
                            .frame(height: 50)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

struct StatItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "DEB887"))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "FFD700"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "8B4513").opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "654321"), lineWidth: 1)
                )
        )
    }
}

struct RightPanelView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "4a2511"), Color(hex: "2d1508")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                
                // The big cookie-style clicker
                CookieClickerButton(gameManager: gameManager)
                
                Spacer()
                
                // Instruction
                Text("✌️ Tap with TWO fingers simultaneously to score! ✌️")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color(hex: "FFD700"))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.7))
                            .overlay(
                                Capsule()
                                    .stroke(Color(hex: "FFD700"), lineWidth: 2)
                            )
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
            
            // Special image overlay
            if let imageName = gameManager.currentSpecialImage {
                SpecialImageView(imageName: imageName)
            }
        }
    }
}

struct CookieClickerButton: View {
    @ObservedObject var gameManager: GameManager
    @State private var touchPoints: [CGPoint] = []
    @State private var isPressed = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Cookie base
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "FFE4B5"),
                                Color(hex: "F4A460"),
                                Color(hex: "D2691E"),
                                Color(hex: "8B4513")
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: geometry.size.width / 2
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "654321"), lineWidth: 8)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 30)
                    .shadow(color: Color(hex: "FFE4B5").opacity(0.5), radius: 20, x: -10, y: -10)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 10, y: 10)
                    .scaleEffect(isPressed ? 0.95 : (gameManager.showSuccess ? 1.05 : 1.0))
                    .animation(.spring(response: 0.3), value: isPressed)
                    .animation(.spring(response: 0.3), value: gameManager.showSuccess)
                
                // Chocolate chips
                ChocolateChips()
                
                // Numbers
                HStack(spacing: 10) {
                    Text("6")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color(hex: "8B4513"), radius: 0, x: 3, y: 3)
                    
                    Text("7")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color(hex: "8B4513"), radius: 0, x: 3, y: 3)
                }
                
                // Touch indicators
                ForEach(touchPoints.indices, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "FFD700").opacity(0.6),
                                    Color(hex: "FF8C00").opacity(0.3),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .position(touchPoints[index])
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Feedback
                if gameManager.showFeedback {
                    Text("+1")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Color(hex: "90EE90"))
                        .shadow(color: Color(hex: "2d5016"), radius: 0, x: 2, y: 2)
                        .shadow(color: .black.opacity(0.8), radius: 5)
                        .offset(y: gameManager.feedbackOffset)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: min(geometry.size.width, geometry.size.height) * 0.7,
                   height: min(geometry.size.width, geometry.size.height) * 0.7)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .contentShape(Circle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            .simultaneousGesture(
                SimultaneousTapGesture()
                    .onEnded { touches in
                        handleTouches(touches, in: geometry)
                    }
            )
        }
    }
    
    private func handleTouches(_ touches: [CGPoint], in geometry: GeometryProxy) {
        touchPoints = touches
        
        if touches.count == 2 {
            gameManager.registerSuccessfulTap()
        } else {
            gameManager.registerFailedTap()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                touchPoints = []
            }
        }
    }
}

struct ChocolateChips: View {
    let chipPositions: [(x: CGFloat, y: CGFloat, size: CGFloat)] = [
        (0.25, 0.30, 0.04),
        (0.70, 0.40, 0.05),
        (0.50, 0.70, 0.035),
        (0.80, 0.75, 0.045),
        (0.35, 0.65, 0.03),
        (0.60, 0.25, 0.04),
        (0.15, 0.55, 0.035),
        (0.45, 0.45, 0.05),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(chipPositions.indices, id: \.self) { index in
                let chip = chipPositions[index]
                Circle()
                    .fill(Color(hex: index % 2 == 0 ? "8B4513" : "654321"))
                    .frame(
                        width: geometry.size.width * chip.size,
                        height: geometry.size.width * chip.size
                    )
                    .position(
                        x: geometry.size.width * chip.x,
                        y: geometry.size.height * chip.y
                    )
            }
        }
    }
}

struct SpecialImageView: View {
    let imageName: String
    @State private var scale: CGFloat = 0
    @State private var rotation: Double = -180
    @State private var opacity: Double = 0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(hex: "FFD700"), lineWidth: 5)
            )
            .shadow(color: Color(hex: "FFD700").opacity(0.8), radius: 30)
            .shadow(color: Color(hex: "FFD700").opacity(0.5), radius: 50)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    scale = 1.2
                    rotation = 10
                    opacity = 1
                }
                
                withAnimation(.easeInOut(duration: 0.2).delay(0.5)) {
                    rotation = -5
                    scale = 1.1
                }
                
                withAnimation(.easeOut(duration: 0.5).delay(1.5)) {
                    scale = 0
                    rotation = 360
                    opacity = 0
                }
            }
    }
}

// Custom gesture for detecting multiple simultaneous touches
struct SimultaneousTapGesture: UIGestureRecognizerRepresentable {
    typealias Value = [CGPoint]
    
    func makeUIGestureRecognizer(context: Context) -> UIMultiTouchGestureRecognizer {
        let recognizer = UIMultiTouchGestureRecognizer()
        recognizer.addTarget(context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        return recognizer
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIMultiTouchGestureRecognizer, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        var onEnded: (([CGPoint]) -> Void)?
        
        @objc func handleTap(_ recognizer: UIMultiTouchGestureRecognizer) {
            if recognizer.state == .ended {
                var points: [CGPoint] = []
                let numberOfTouches = recognizer.numberOfTouches
                
                for i in 0..<numberOfTouches {
                    points.append(recognizer.location(ofTouch: i, in: recognizer.view))
                }
                
                onEnded?(points)
            }
        }
    }
}

extension SimultaneousTapGesture {
    func onEnded(_ action: @escaping ([CGPoint]) -> Void) -> Self {
        var gesture = self
        gesture.makeCoordinator().onEnded = action
        return gesture
    }
}

class UIMultiTouchGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
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
