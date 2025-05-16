import Foundation
import UserNotifications

class NotificationManager {
    @MainActor static let shared = NotificationManager()
    
    private init() {}

    // Request permission for notifications
    @MainActor func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // Check if notifications are authorized
    @MainActor func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    // Schedule a notification for a habit
    
    func scheduleNotification(for habit: Habit) {
        guard habit.notify else { return }

        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete your habit: \(habit.name)!"
        content.sound = .default

        // Convert notification time to local timezone
        let userCalendar = Calendar.current
        let triggerDate = userCalendar.dateComponents([.hour, .minute], from: habit.notificationTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                formatter.timeZone = TimeZone.current
                let formattedTime = formatter.string(from: habit.notificationTime)
                print("Notification scheduled for \(habit.name) at \(formattedTime) (Local Time)")
            }
        }
    }


    // Update an existing notification (remove old, add new)
    func updateNotification(for habit: Habit) {
        removeNotification(for: habit)
        scheduleNotification(for: habit)
    }

    // Remove notification for a specific habit
    func removeNotification(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("Notification removed for \(habit.name)")
    }

    // Remove all notifications 
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications removed")
    }
}
