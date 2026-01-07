import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var score: Int = 0
    @Published var totalTaps: Int = 0
    @Published var successfulTaps: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var scoreScale: CGFloat = 1.0
    @Published var special67Count: Int = 0
    @Published var showSuccess: Bool = false
    @Published var showFeedback: Bool = false
    @Published var feedbackOffset: CGFloat = 0
    @Published var currentSpecialImage: String? = nil
    
    // Add your special images here - these should be in your Assets catalog
    private let specialImages = [
        "special1",
        "special2", 
        "special3",
        "special4",
        "special5"
    ]
    
    private let defaults = UserDefaults.standard
    
    init() {
        loadGameData()
    }
    
    var successRateString: String {
        guard totalTaps > 0 else { return "0%" }
        let rate = (Double(successfulTaps) / Double(totalTaps)) * 100
        return String(format: "%.1f%%", rate)
    }
    
    func registerSuccessfulTap() {
        score += 1
        totalTaps += 1
        successfulTaps += 1
        currentStreak += 1
        
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        
        // Check if score ends in 67
        if String(score).hasSuffix("67") {
            showSpecialImage()
            special67Count += 1
        }
        
        animateScore()
        animateFeedback()
        animateSuccess()
        saveGameData()
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func registerFailedTap() {
        totalTaps += 1
        currentStreak = 0
        saveGameData()
        
        // Light haptic for failed tap
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func animateScore() {
        withAnimation(.spring(response: 0.3)) {
            scoreScale = 1.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3)) {
                self.scoreScale = 1.0
            }
        }
    }
    
    private func animateFeedback() {
        showFeedback = true
        feedbackOffset = 0
        
        withAnimation(.easeOut(duration: 1.5)) {
            feedbackOffset = -150
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showFeedback = false
            self.feedbackOffset = 0
        }
    }
    
    private func animateSuccess() {
        showSuccess = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showSuccess = false
        }
    }
    
    private func showSpecialImage() {
        // Pick a random image
        let randomImage = specialImages.randomElement() ?? specialImages[0]
        currentSpecialImage = randomImage
        
        // Play special sound effect
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Hide image after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.currentSpecialImage = nil
            }
        }
    }
    
    func resetStats() {
        score = 0
        totalTaps = 0
        successfulTaps = 0
        currentStreak = 0
        bestStreak = 0
        special67Count = 0
        saveGameData()
    }
    
    private func saveGameData() {
        defaults.set(score, forKey: "score")
        defaults.set(totalTaps, forKey: "totalTaps")
        defaults.set(successfulTaps, forKey: "successfulTaps")
        defaults.set(bestStreak, forKey: "bestStreak")
        defaults.set(special67Count, forKey: "special67Count")
    }
    
    private func loadGameData() {
        score = defaults.integer(forKey: "score")
        totalTaps = defaults.integer(forKey: "totalTaps")
        successfulTaps = defaults.integer(forKey: "successfulTaps")
        bestStreak = defaults.integer(forKey: "bestStreak")
        special67Count = defaults.integer(forKey: "special67Count")
    }
}
