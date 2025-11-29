import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorization()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    self.scheduleDefaultNotifications()
                }
            }
        }
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Bildirim Zamanlama
    
    func scheduleDefaultNotifications() {
        // Günlük hatırlatıcı - sabah 9:00
        scheduleDailyReminder(
            hour: 9,
            minute: 0,
            title: "Günaydın! 🌅",
            body: "Bugün de sigara içmeden geçen bir gün olsun. Sen yapabilirsin!"
        )
        
        // Öğle motivasyonu - 12:00
        scheduleDailyReminder(
            hour: 12,
            minute: 0,
            title: "Yarı yol! 💪",
            body: "Günün yarısını başarıyla geçirdin. Devam et!"
        )
        
        // Akşam hatırlatıcı - 20:00
        scheduleDailyReminder(
            hour: 20,
            minute: 0,
            title: "Günlük kaydını yaptın mı? 📝",
            body: "Bugünkü ilerlemeni kaydet ve rozetlerini kontrol et!"
        )
    }
    
    private func scheduleDailyReminder(hour: Int, minute: Int, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = "daily_\(hour)_\(minute)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim zamanlanamadı: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Özel Bildirimler
    
    func scheduleMotivationalNotification(after seconds: TimeInterval = 3600) {
        let motivationalMessages = [
            ("Güçlüsün! 💪", "Her geçen dakika sigarasız geçen bir dakika. Gurur duy!"),
            ("Harika gidiyorsun! ⭐", "Sigara bırakma yolculuğunda ilerlemeye devam ediyorsun."),
            ("Sen yapabilirsin! 🎯", "Hedeflerine bir adım daha yaklaştın."),
            ("Başarılı oluyorsun! 🏆", "Her gün daha sağlıklı bir sen için adım atıyorsun."),
            ("Devam et! 🚀", "Pes etme, başarı senin olacak!")
        ]
        
        let (title, body) = motivationalMessages.randomElement() ?? motivationalMessages[0]
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleCravingAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Kraving mi hissediyorsun? 🆘"
        content.body = "Hemen nefes egzersizi yap veya dikkatini dağıt. Yanındayız!"
        content.sound = .default
        content.categoryIdentifier = "CRAVING_ALERT"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "craving_alert",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleMilestoneNotification(milestone: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Tebrikler!"
        content.body = "\(milestone): \(message)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(
            identifier: "milestone_\(milestone)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleAchievementUnlocked(achievementName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🏅 Rozet Kazandın!"
        content.body = "\(achievementName) rozetini açtın! Harika iş çıkarıyorsun."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "achievement_\(achievementName)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Bildirim Yönetimi
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
}


