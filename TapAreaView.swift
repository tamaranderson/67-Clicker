import SwiftUI

struct TapAreaView: View {
    @ObservedObject var gameManager: GameManager
    @State private var touchPoints: [CGPoint] = []
    @State private var showSuccess = false
    @State private var feedbackOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Colorful background with glow
                RoundedRectangle(cornerRadius: 35)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.cyan.opacity(0.3),
                                Color.pink.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 5
                            )
                    )
                    .shadow(color: .cyan.opacity(0.6), radius: 20)
                    .shadow(color: .pink.opacity(0.6), radius: 20)
                    .shadow(color: showSuccess ? .yellow.opacity(0.9) : .clear, radius: 30)
                
                // Playful numbers with multiple colors
                HStack(spacing: 10) {
                    Text("6")
                        .font(.system(size: geometry.size.height * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red, .orange, .yellow],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.5), radius: 3)
                    
                    Text("7")
                        .font(.system(size: geometry.size.height * 0.35, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue, .purple],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .white.opacity(0.5), radius: 3)
                }
                .opacity(0.4)
                
                // Colorful touch indicators with stars
                ForEach(touchPoints.indices, id: \.self) { index in
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        .yellow.opacity(0.8),
                                        .orange.opacity(0.4),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        // Star emoji
                        Text(index == 0 ? "⭐" : "✨")
                            .font(.system(size: 50))
                    }
                    .position(touchPoints[index])
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Success feedback with explosion effect
                if showSuccess {
                    VStack(spacing: 5) {
                        Text("🎉")
                            .font(.system(size: 40))
                        Text("+1")
                            .font(.system(size: 70, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .white, radius: 5)
                            .shadow(color: .green, radius: 10)
                        Text("🎉")
                            .font(.system(size: 40))
                    }
                    .offset(y: feedbackOffset)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        // This is a workaround - we'll use simultaneousGesture for multi-touch
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
        
        // Check if exactly 2 fingers touched
        if touches.count == 2 {
            gameManager.registerSuccessfulTap()
            showSuccessAnimation()
        } else {
            gameManager.registerFailedTap()
        }
        
        // Clear touch points after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                touchPoints = []
            }
        }
    }
    
    private func showSuccessAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            showSuccess = true
            feedbackOffset = -100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showSuccess = false
                feedbackOffset = 0
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

// Custom UIGestureRecognizer for multi-touch
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
