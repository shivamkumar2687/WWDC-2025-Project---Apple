import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var streak: Int = 0
    var goal: Int = 10
    var creationDate: Date = Date()
    var notify: Bool = false
    var notificationTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()
    var lastCompletedDate: Date?  // Track last completion date
}
