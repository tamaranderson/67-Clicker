import SwiftUI

struct TapAreaView: View {
    @ObservedObject var gameManager: GameManager
    @State private var touchPoints: [CGPoint] = []
    @State private var showSuccess = false
    @State private var feedbackOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(showSuccess ? 0.3 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.2), lineWidth: 3)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 10)
                
                // Numbers
                Text("6 7")
                    .font(.system(size: geometry.size.height * 0.3, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
                
                // Touch indicators
                ForEach(touchPoints.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 60, height: 60)
                        .position(touchPoints[index])
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Success feedback
                if showSuccess {
                    Text("+1")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.green)
                        .shadow(color: .black.opacity(0.5), radius: 5)
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
