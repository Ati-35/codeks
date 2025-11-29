import Foundation
import SwiftUI

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var userProfile: UserProfile?
    @Published var dailyRecords: [DailyRecord] = []
    @Published var cravingRecords: [CravingRecord] = []
    @Published var userGoals: [UserGoal] = []
    @Published var achievements: [UserAchievement] = []
    @Published var appSettings: AppSettings = AppSettings()
    @Published var hasCompletedOnboarding: Bool = false
    
    private let defaults = UserDefaults.standard
    
    // UserDefaults anahtarlari
    private enum Keys {
        static let userProfile = "userProfile"
        static let dailyRecords = "dailyRecords"
        static let cravingRecords = "cravingRecords"
        static let userGoals = "userGoals"
        static let achievements = "achievements"
        static let appSettings = "appSettings"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {
        loadAllData()
    }
    
    // MARK: - Veri Yukleme
    
    func loadAllData() {
        loadUserProfile()
        loadDailyRecords()
        loadCravingRecords()
        loadUserGoals()
        loadAchievements()
        loadAppSettings()
        hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    private func loadUserProfile() {
        if let data = defaults.data(forKey: Keys.userProfile),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }
    
    private func loadDailyRecords() {
        if let data = defaults.data(forKey: Keys.dailyRecords),
           let records = try? JSONDecoder().decode([DailyRecord].self, from: data) {
            dailyRecords = records
        }
    }
    
    private func loadCravingRecords() {
        if let data = defaults.data(forKey: Keys.cravingRecords),
           let records = try? JSONDecoder().decode([CravingRecord].self, from: data) {
            cravingRecords = records
        }
    }
    
    private func loadUserGoals() {
        if let data = defaults.data(forKey: Keys.userGoals),
           let goals = try? JSONDecoder().decode([UserGoal].self, from: data) {
            userGoals = goals
        } else {
            // Varsayilan hedefler
            createDefaultGoals()
        }
    }
    
    private func loadAchievements() {
        if let data = defaults.data(forKey: Keys.achievements),
           let achievementList = try? JSONDecoder().decode([UserAchievement].self, from: data) {
            achievements = achievementList
        } else {
            // Varsayilan rozetler
            createDefaultAchievements()
        }
    }
    
    private func loadAppSettings() {
        if let data = defaults.data(forKey: Keys.appSettings),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            appSettings = settings
        }
    }
    
    // MARK: - Veri Kaydetme
    
    func saveUserProfile(_ profile: UserProfile) {
        userProfile = profile
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: Keys.userProfile)
        }
    }
    
    func saveDailyRecord(_ record: DailyRecord) {
        // Ayni gun icin mevcut kaydi guncelle veya yeni ekle
        if let index = dailyRecords.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: record.date) }) {
            dailyRecords[index] = record
        } else {
            dailyRecords.append(record)
        }
        
        dailyRecords.sort { $0.date > $1.date }
        
        if let data = try? JSONEncoder().encode(dailyRecords) {
            defaults.set(data, forKey: Keys.dailyRecords)
        }
        
        checkAndUnlockAchievements()
    }
    
    func saveCravingRecord(_ record: CravingRecord) {
        cravingRecords.append(record)
        cravingRecords.sort { $0.date > $1.date }
        
        if let data = try? JSONEncoder().encode(cravingRecords) {
            defaults.set(data, forKey: Keys.cravingRecords)
        }
    }
    
    func saveUserGoal(_ goal: UserGoal) {
        if let index = userGoals.firstIndex(where: { $0.id == goal.id }) {
            userGoals[index] = goal
        } else {
            userGoals.append(goal)
        }
        
        if let data = try? JSONEncoder().encode(userGoals) {
            defaults.set(data, forKey: Keys.userGoals)
        }
    }
    
    func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            defaults.set(data, forKey: Keys.achievements)
        }
    }
    
    func saveAppSettings(_ settings: AppSettings) {
        appSettings = settings
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: Keys.appSettings)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        defaults.set(true, forKey: Keys.hasCompletedOnboarding)
    }
    
    // MARK: - Yardimci Fonksiyonlar
    
    func getTodayRecord() -> DailyRecord? {
        dailyRecords.first { Calendar.current.isDateInToday($0.date) }
    }
    
    func getWeeklyRecords() -> [DailyRecord] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return dailyRecords.filter { $0.date >= weekAgo }
    }
    
    func getSuccessRate(days: Int = 7) -> Double {
        let records = dailyRecords.prefix(days)
        guard !records.isEmpty else { return 0 }
        
        let successCount = records.filter { !$0.didSmoke }.count
        return Double(successCount) / Double(records.count)
    }
    
    // MARK: - Varsayilan Veriler
    
    private func createDefaultGoals() {
        userGoals = [
            UserGoal(
                title: "1 Ay Sigara İçmemek",
                targetValue: 30,
                currentValue: 0,
                unit: "gün",
                icon: "flame.fill",
                color: "red",
                deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                isCompleted: false
            ),
            UserGoal(
                title: "500 TL Biriktir",
                targetValue: 500,
                currentValue: 0,
                unit: "TL",
                icon: "banknote.fill",
                color: "green",
                deadline: nil,
                isCompleted: false
            ),
            UserGoal(
                title: "20 Egzersiz Tamamla",
                targetValue: 20,
                currentValue: 0,
                unit: "egzersiz",
                icon: "figure.run",
                color: "blue",
                deadline: nil,
                isCompleted: false
            )
        ]
        
        if let data = try? JSONEncoder().encode(userGoals) {
            defaults.set(data, forKey: Keys.userGoals)
        }
    }
    
    private func createDefaultAchievements() {
        let achievementIds = [
            "first_day", "one_week", "100_tl", "breath_master", "one_month",
            "smoke_free_week", "craving_warrior", "three_months", "six_months", "one_year"
        ]
        
        achievements = achievementIds.map { UserAchievement(achievementId: $0, progress: 0) }
        saveAchievements()
    }
    
    private func checkAndUnlockAchievements() {
        guard let profile = userProfile else { return }
        
        // İlk gün rozeti
        if profile.daysSinceQuit >= 1 {
            unlockAchievement("first_day")
        }
        
        // Bir hafta rozeti
        if profile.daysSinceQuit >= 7 {
            unlockAchievement("one_week")
        }
        
        // 100 TL rozeti
        if profile.moneySaved >= 100 {
            unlockAchievement("100_tl")
        }
        
        // Bir ay rozeti
        if profile.daysSinceQuit >= 30 {
            unlockAchievement("one_month")
        }
    }
    
    private func unlockAchievement(_ achievementId: String) {
        if let index = achievements.firstIndex(where: { $0.achievementId == achievementId && !$0.isUnlocked }) {
            achievements[index].unlockedDate = Date()
            achievements[index].progress = 1.0
            saveAchievements()
        }
    }
    
    // MARK: - Reset
    
    func resetAllData() {
        userProfile = nil
        dailyRecords = []
        cravingRecords = []
        userGoals = []
        achievements = []
        appSettings = AppSettings()
        hasCompletedOnboarding = false
        
        defaults.removeObject(forKey: Keys.userProfile)
        defaults.removeObject(forKey: Keys.dailyRecords)
        defaults.removeObject(forKey: Keys.cravingRecords)
        defaults.removeObject(forKey: Keys.userGoals)
        defaults.removeObject(forKey: Keys.achievements)
        defaults.removeObject(forKey: Keys.appSettings)
        defaults.removeObject(forKey: Keys.hasCompletedOnboarding)
    }
}

