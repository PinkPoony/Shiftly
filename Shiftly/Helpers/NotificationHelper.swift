import Foundation
import UserNotifications

struct NotificationHelper {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                scheduleDailyNotification()
            }
        }
    }
    
    static func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Shiftly"
        content.body = "Проверь кто работает завтра 👀"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        center.add(request)
    }
}
