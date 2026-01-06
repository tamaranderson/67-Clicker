import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var score: Int = 0
    @Published var totalTaps: Int = 0
    @Published var successfulTaps: Int = 0
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var scoreScale: CGFloat = 1.0
    
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
        
        animateScore()
        saveGameData()
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
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
    
    func resetStats() {
        score = 0
        totalTaps = 0
        successfulTaps = 0
        currentStreak = 0
        bestStreak = 0
        saveGameData()
    }
    
    private func saveGameData() {
        defaults.set(score, forKey: "score")
        defaults.set(totalTaps, forKey: "totalTaps")
        defaults.set(successfulTaps, forKey: "successfulTaps")
        defaults.set(bestStreak, forKey: "bestStreak")
    }
    
    private func loadGameData() {
        score = defaults.integer(forKey: "score")
        totalTaps = defaults.integer(forKey: "totalTaps")
        successfulTaps = defaults.integer(forKey: "successfulTaps")
        bestStreak = defaults.integer(forKey: "bestStreak")
    }
}
