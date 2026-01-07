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
                    colors: [Color(hex: "7c3aed"), Color(hex: "6b21a8")],
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
            LinearGradient(
                colors: [Color(hex: "5a67d8"), Color(hex: "4c51bf")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gear")
                                .font(.system(size: 24))
                                .foregroundColor(Color(hex: "fbbf24"))
                                .padding()
                        }
                    }
                    
                    VStack {
                        Text("67 Clicker")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "fbbf24"))
                            .shadow(color: Color(hex: "7c3aed"), radius: 0, x: 3, y: 3)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "8b5cf6").opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "a78bfa"), lineWidth: 2)
                            )
                    )
                    .padding(.horizontal)
                    
                    // Top Stats Bar
                    HStack(spacing: 15) {
                        TopStatCard(label: "Total Taps", value: "\(gameManager.totalTaps)")
                        TopStatCard(label: "Skibidi Rate", value: gameManager.successRateString)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        Text("67 pairs tapped")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "fcd34d"))
                        
                        Text("\(gameManager.score)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color(hex: "fbbf24"))
                            .shadow(color: Color(hex: "7c3aed"), radius: 0, x: 2, y: 2)
                            .scaleEffect(gameManager.scoreScale)
                            .animation(.spring(response: 0.3), value: gameManager.scoreScale)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "fbbf24"), lineWidth: 3)
                            )
                    )
                    .padding(.horizontal)
                    
                    // Friend Leaderboard
                    LeaderboardView(gameManager: gameManager)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        Text("📊 Statistics")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "fbbf24"))
                        
                        StatItemView(label: "Best Streak", value: "\(gameManager.bestStreak)")
                        StatItemView(label: "Special 67s Hit", value: "\(gameManager.special67Count)")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "a78bfa"), lineWidth: 2)
                            )
                    )
                    .padding(.horizontal)
                    
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

struct TopStatCard: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "c4b5fd"))
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: "fbbf24"))
                .shadow(color: .black.opacity(0.3), radius: 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "a78bfa"), lineWidth: 2)
                )
        )
    }
}

struct StatItemView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "c4b5fd"))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "fbbf24"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "8b5cf6").opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "8b5cf6"), lineWidth: 1)
                )
        )
    }
}

struct LeaderboardView: View {
    @ObservedObject var gameManager: GameManager
    @State private var friendName: String = ""
    @State private var friends: [Friend] = []
    @State private var playerName: String = "You"
    
    struct Friend: Identifiable, Codable {
        let id = UUID()
        var name: String
        var score: Int
        var rate: String
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("🏆 Friend Leaderboard")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "34d399"))
            
            HStack(spacing: 10) {
                TextField("Friend's name", text: $friendName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 14))
                
                Button(action: addFriend) {
                    Text("Add")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color(hex: "10b981"))
                        .cornerRadius(8)
                }
            }
            
            HStack(spacing: 10) {
                Button(action: shareScore) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(hex: "10b981"))
                    .cornerRadius(8)
                }
                
                Button(action: { friends = loadFriends() }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(hex: "10b981"))
                    .cornerRadius(8)
                }
            }
            
            ScrollView {
                VStack(spacing: 8) {
                    if leaderboardData.isEmpty {
                        Text("Add friends to compete!")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "c4b5fd"))
                            .padding(.vertical, 20)
                    } else {
                        ForEach(Array(leaderboardData.enumerated()), id: \.offset) { index, player in
                            LeaderboardItemView(
                                rank: index + 1,
                                name: player.name,
                                score: player.score,
                                rate: player.rate,
                                isCurrentUser: player.name == playerName
                            )
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(hex: "10b981"), lineWidth: 2)
                )
        )
        .onAppear {
            friends = loadFriends()
        }
    }
    
    var leaderboardData: [(name: String, score: Int, rate: String)] {
        var data = [(name: String, score: Int, rate: String)]()
        data.append((playerName, gameManager.score, gameManager.successRateString))
        for friend in friends {
            data.append((friend.name, friend.score, friend.rate))
        }
        return data.sorted { $0.score > $1.score }
    }
    
    func addFriend() {
        let name = friendName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        guard !friends.contains(where: { $0.name == name }) else {
            friendName = ""
            return
        }
        
        let newFriend = Friend(
            name: name,
            score: Int.random(in: 0...(gameManager.score > 0 ? gameManager.score : 100)),
            rate: String(format: "%.1f%%", Double.random(in: 0...100))
        )
        friends.append(newFriend)
        saveFriends()
        friendName = ""
    }
    
    func shareScore() {
        let message = "I scored \(gameManager.score) in 67 Clicker with a \(gameManager.successRateString) Skibidi Rate! Can you beat me?"
        UIPasteboard.general.string = message
    }
    
    func loadFriends() -> [Friend] {
        guard let data = UserDefaults.standard.data(forKey: "friends"),
              let decoded = try? JSONDecoder().decode([Friend].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func saveFriends() {
        if let encoded = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(encoded, forKey: "friends")
        }
    }
}

struct LeaderboardItemView: View {
    let rank: Int
    let name: String
    let score: Int
    let rate: String
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "fbbf24"))
                .frame(width: 30)
            
            Text(name + (isCurrentUser ? " (You)" : ""))
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "d1fae5"))
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(score)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "fbbf24"))
                Text(rate)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "c4b5fd"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrentUser ? Color(hex: "fbbf24").opacity(0.2) : Color(hex: "10b981").opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isCurrentUser ? Color(hex: "fbbf24") : Color(hex: "10b981"), lineWidth: isCurrentUser ? 2 : 1)
                )
        )
    }
}

struct RightPanelView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "7c3aed"), Color(hex: "6b21a8")],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                ClickerButton(gameManager: gameManager)
                Spacer()
                
                Text("✌️ Tap with TWO fingers simultaneously to score! ✌️")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "fbbf24"))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.7))
                            .overlay(Capsule().stroke(Color(hex: "fbbf24"), lineWidth: 2))
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
            
            if let imageName = gameManager.currentSpecialImage {
                SpecialImageView(imageName: imageName)
            }
        }
    }
}

struct ClickerButton: View {
    @ObservedObject var gameManager: GameManager
    @State private var touchPoints: [CGPoint] = []
    @State private var isPressed = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.25), Color.black.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "fbbf24"), lineWidth: 4))
                    .shadow(color: .black.opacity(0.5), radius: 30)
                    .scaleEffect(isPressed ? 0.95 : (gameManager.showSuccess ? 1.05 : 1.0))
                    .animation(.spring(response: 0.3), value: isPressed)
                    .animation(.spring(response: 0.3), value: gameManager.showSuccess)
                
                HStack(spacing: 10) {
                    Text("6")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "fbbf24"), Color(hex: "fb923c")], startPoint: .top, endPoint: .bottom))
                        .shadow(color: Color(hex: "7c3aed"), radius: 0, x: 3, y: 3)
                    Text("7")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "fbbf24"), Color(hex: "fb923c")], startPoint: .top, endPoint: .bottom))
                        .shadow(color: Color(hex: "7c3aed"), radius: 0, x: 3, y: 3)
                }
                
                ForEach(touchPoints.indices, id: \.self) { index in
                    Circle()
                        .fill(RadialGradient(colors: [Color(hex: "fbbf24").opacity(0.6), Color(hex: "fb923c").opacity(0.3), .clear], center: .center, startRadius: 0, endRadius: 40))
                        .frame(width: 80, height: 80)
                        .position(touchPoints[index])
                        .transition(.scale.combined(with: .opacity))
                }
                
                if gameManager.showFeedback {
                    Text("+1")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(Color(hex: "10b981"))
                        .shadow(color: Color(hex: "065f46"), radius: 0, x: 2, y: 2)
                        .offset(y: gameManager.feedbackOffset)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: min(geometry.size.width, geometry.size.height) * 0.7, height: min(geometry.size.width, geometry.size.height) * 0.7)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .contentShape(Rectangle())
            .simultaneousGesture(DragGesture(minimumDistance: 0).onChanged { _ in isPressed = true }.onEnded { _ in isPressed = false })
            .simultaneousGesture(SimultaneousTapGesture().onEnded { touches in handleTouches(touches, in: geometry) })
        }
    }
    
    private func handleTouches(_ touches: [CGPoint], in geometry: GeometryProxy) {
        touchPoints = touches
        if touches.count == 2 { gameManager.registerSuccessfulTap() } else { gameManager.registerFailedTap() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { withAnimation { touchPoints = [] } }
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
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "fbbf24"), lineWidth: 5))
            .shadow(color: Color(hex: "fbbf24").opacity(0.8), radius: 30)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) { scale = 1.2; rotation = 10; opacity = 1 }
                withAnimation(.easeInOut(duration: 0.2).delay(0.5)) { rotation = -5; scale = 1.1 }
                withAnimation(.easeOut(duration: 0.5).delay(1.5)) { scale = 0; rotation = 360; opacity = 0 }
            }
    }
}

struct SimultaneousTapGesture: UIGestureRecognizerRepresentable {
    typealias Value = [CGPoint]
    func makeUIGestureRecognizer(context: Context) -> UIMultiTouchGestureRecognizer {
        let recognizer = UIMultiTouchGestureRecognizer()
        recognizer.addTarget(context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        return recognizer
    }
    func updateUIGestureRecognizer(_ recognizer: UIMultiTouchGestureRecognizer, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator: NSObject {
        var onEnded: (([CGPoint]) -> Void)?
        @objc func handleTap(_ recognizer: UIMultiTouchGestureRecognizer) {
            if recognizer.state == .ended {
                var points: [CGPoint] = []
                for i in 0..<recognizer.numberOfTouches {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) { super.touchesBegan(touches, with: event); state = .began }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) { super.touchesEnded(touches, with: event); state = .ended }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) { super.touchesCancelled(touches, with: event); state = .cancelled }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView().environmentObject(PurchaseManager()) }
}
