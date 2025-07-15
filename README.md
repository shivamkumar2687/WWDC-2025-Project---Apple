A simple and motivating habit tracker that helps users build consistent routines and maintain daily streaks.

🎯 Purpose

To help users:

Build and maintain daily habits.
Visualize their progress.
Stay motivated with streak-based tracking and motivational quotes.
Receive reminders to maintain consistency.
📱 Core Features

1. Onboarding Flow
Friendly introduction to app features.
Skippable onboarding with persistent flag (UserDefaults).

3. Add Habits
Users can add custom habits (e.g., "Drink Water", "Meditate").
Each habit has:
Name
Current streak count
A goal (default: 30 days)

4. Habit List View
Displays all user habits in a list.
Each habit card shows:
Name
Progress bar for the streak
“+” button to increment streak
Calendar view access

6. Streak Calendar
Shows progress for 30 days in a circular format.
Days marked green indicate successful completion.

8. Progress Visualization
Bar chart displaying current streaks of all habits.
Uses Swift Charts to give visual insights.

10. Motivational Quotes
Random motivational quote shown in the habit list view.
Keeps the user inspired daily.

12. Daily Notifications
Local notification reminder (e.g., “Don’t forget to complete your habit!”).
Permission requested from the user.
Triggered daily at a set time (default: 8 AM).

14. Settings View
Lets users re-enable notification permission.
Can add more controls like dark mode toggle, reset data, etc.

🧩 Tech Stack

Language: Swift
UI Framework: SwiftUI
Storage: UserDefaults (for habit persistence)
Notifications: UNUserNotificationCenter (local notifications)
Charts: Swift Charts framework



![Alt text](https://github.com/shivamkumar2687/WWDC-2025-Project---Apple/blob/main/StreakMate.swiftpm/Screenshot%202025-05-18%20at%205.09.49%E2%80%AFPM.png?raw=true)

