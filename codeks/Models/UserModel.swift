import Foundation
import SwiftUI

// Kullanici profil modeli
struct UserProfile: Codable {
    var name: String
    var quitDate: Date
    var cigarettesPerDay: Int
    var pricePerPack: Double
    var cigarettesPerPack: Int
    var motivations: [String]
    var profileImage: String?
    
    // Hesaplanmis degerler
    var daysSinceQuit: Int {
        Calendar.current.dateComponents([.day], from: quitDate, to: Date()).day ?? 0
    }
    
    var cigarettesAvoided: Int {
        daysSinceQuit * cigarettesPerDay
    }
    
    var moneySaved: Double {
        let packsAvoided = Double(cigarettesAvoided) / Double(cigarettesPerPack)
        return packsAvoided * pricePerPack
    }
    
    var healthScore: Int {
        // 0-100 arasi saglik skoru
        min(100, daysSinceQuit * 2)
    }
}

// Gunluk takip kaydi
struct DailyRecord: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var didSmoke: Bool
    var mood: MoodLevel
    var cravingCount: Int
    var notes: String?
    
    enum MoodLevel: String, Codable, CaseIterable {
        case veryBad = "Çok Kötü"
        case bad = "Kötü"
        case neutral = "Nötr"
        case good = "İyi"
        case veryGood = "Çok İyi"
        
        var emoji: String {
            switch self {
            case .veryBad: return "😢"
            case .bad: return "😕"
            case .neutral: return "😐"
            case .good: return "🙂"
            case .veryGood: return "😊"
            }
        }
        
        var color: Color {
            switch self {
            case .veryBad: return Color(red: 0.95, green: 0.36, blue: 0.42)
            case .bad: return Color(red: 1.00, green: 0.54, blue: 0.24)
            case .neutral: return Color.gray
            case .good: return Color(red: 0.38, green: 0.73, blue: 1.00)
            case .veryGood: return Color(red: 0.36, green: 0.84, blue: 0.65)
            }
        }
    }
}

// Kraving kaydi
struct CravingRecord: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var intensity: Int // 1-10
    var trigger: String?
    var copingStrategy: String?
    var duration: TimeInterval?
    var wasSuccessful: Bool
}

// Hedef modeli
struct UserGoal: Codable, Identifiable {
    var id = UUID()
    var title: String
    var targetValue: Double
    var currentValue: Double
    var unit: String
    var icon: String
    var color: String
    var deadline: Date?
    var isCompleted: Bool
    
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(1.0, currentValue / targetValue)
    }
}

// Rozet modeli
struct UserAchievement: Codable, Identifiable {
    var id = UUID()
    var achievementId: String
    var unlockedDate: Date?
    var progress: Double
    
    var isUnlocked: Bool {
        unlockedDate != nil
    }
}

// Bildirim tercihleri
struct NotificationPreferences: Codable {
    var enableDailyReminders: Bool = true
    var enableMotivation: Bool = true
    var enableCravingAlerts: Bool = true
    var enableMilestones: Bool = true
    var quietHoursStart: Date?
    var quietHoursEnd: Date?
}

// Uygulama ayarlari
struct AppSettings: Codable {
    var darkMode: Bool = false
    var selectedTheme: String = "default"
    var enableSounds: Bool = true
    var enableHaptics: Bool = true
    var language: String = "tr"
    var notificationPreferences: NotificationPreferences = NotificationPreferences()
}

