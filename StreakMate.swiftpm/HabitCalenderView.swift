
import SwiftUI

struct HabitCalendarView: View {
    var habit: Habit

    // Default to 30 days or use the habit's streak goal
    var totalDays: Int {
        habit.goal > 0 ? habit.goal : 30
    }

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)

    var body: some View {
        VStack {
            Text("Streak Calendar for \(habit.name)")
                .font(.title2.bold())
                .padding()

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1...totalDays, id: \.self) { day in
                    ZStack {
                        Circle()
                            .fill(habit.streak >= day ? Color.green.opacity(0.9) : Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .shadow(radius: 2)

                        Text("\(day)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
