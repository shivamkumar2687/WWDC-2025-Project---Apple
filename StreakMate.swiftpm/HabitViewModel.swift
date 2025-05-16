import Foundation
import SwiftUI
import UserNotifications

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var sortOption: SortOption = .name
    
    init() {
        loadHabits()
    }
    
    // Function to add a habit
    @MainActor func addHabit(name: String, notify: Bool = false, notificationTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()) {
        let newHabit = Habit(name: name, streak: 0, goal: 30, notify: notify, notificationTime: notificationTime)
        habits.append(newHabit)
        saveHabits()
        
        // Schedule notification if enabled
        //        if notify {
        //            scheduleNotification(for: newHabit)
        //        }
        if notify {
            NotificationManager.shared.scheduleNotification(for: newHabit)
        }
    }
    
    // Function to increment streak
    func incrementStreak(for habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
        // Only increment if streak is less than the goal
        if habits[index].streak < habits[index].goal {
         habits[index].streak += 1
                   }
        saveHabits()
               }
    }
    
    
    
    // Sort habits
    var sortedHabits: [Habit] {
        switch sortOption {
        case .name:
            return habits.sorted { $0.name < $1.name }
        case .streak:
            return habits.sorted { $0.streak > $1.streak }
        }
    }
    
    // Notification Scheduling
    func scheduleNotification(for habit: Habit) {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete \(habit.name) today!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: habit.notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    @MainActor func updateHabit(_ updatedHabit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == updatedHabit.id }) {
            habits[index] = updatedHabit
            saveHabits()
            
            //            if updatedHabit.notify {
            //                scheduleNotification(for: updatedHabit)
            //            }
            NotificationManager.shared.updateNotification(for: updatedHabit)
        }
    }
    
    // Delete habit
    @MainActor func deleteHabit(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits.remove(at: index)
            saveHabits() // Ensure changes are saved
            NotificationManager.shared.removeNotification(for: habit) // Remove scheduled notification
        }
    }
    
    // for streak check
    func completeHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            let today = Calendar.current.startOfDay(for: Date()) // Remove time for accurate comparison
            
            if let lastDate = habits[index].lastCompletedDate {
                let lastCompletionDay = Calendar.current.startOfDay(for: lastDate) // Remove time for accurate comparison
                
                // Check if the habit was already completed today
                if lastCompletionDay == today {
                    print("Habit '\(habit.name)' was already completed today. No update.")
                    return // Prevent duplicate updates
                }
                
                // If the habit was completed yesterday, continue the streak
                if Calendar.current.isDate(lastCompletionDay, inSameDayAs: today.addingTimeInterval(-86400)) {
                    // Only increment if streak is less than goal
                    if habits[index].streak < habit.goal {
                        habits[index].streak += 1
                        print("Streak continued! New streak: \(habits[index].streak)")
                    } else {
                        print("Goal reached! Streak can't increase further.")
                    }
                } else {
                    // If a day is missed, reset the streak
                    habits[index].streak = 1
                    print("🔄 Streak reset to 1 for \(habit.name)")
                }
            } else {
                // First-time completion
                habits[index].streak = 1
                print("First-time completion for \(habit.name), streak set to 1.")
            }
            
            // Update last completed date
            habits[index].lastCompletedDate = today
            saveHabits()
        }
    }

    
    func saveHabits() {
        do {
            let encodedData = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(encodedData, forKey: "savedHabits")
            print("💾 Habits saved successfully.")
        } catch {
            print("⚠️ Failed to save habits: \(error.localizedDescription)")
        }
    }
    
    func loadHabits() {
        if let savedData = UserDefaults.standard.data(forKey: "savedHabits") {
            do {
                habits = try JSONDecoder().decode([Habit].self, from: savedData)
                print("Habits loaded successfully.")
            } catch {
                print("Failed to load habits: \(error.localizedDescription)")
            }
        }
    }
}
// Sorting Options
enum SortOption {
    case name, streak
}
