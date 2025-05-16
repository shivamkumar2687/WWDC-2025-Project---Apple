
import SwiftUI

struct EditHabitView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State var habit: Habit
    @State private var enableNotification: Bool
    @State private var notificationTime: Date
    
    @Environment(\.presentationMode) var presentationMode

    init(habit: Habit, viewModel: HabitViewModel) {
        self.viewModel = viewModel
        self._habit = State(initialValue: habit)
        self._enableNotification = State(initialValue: habit.notify)
        self._notificationTime = State(initialValue: habit.notificationTime)
    }

    var body: some View {
        NavigationView {
            VStack {

                Form {
                    Section(header: Text("Habit Details")) {
                        TextField("Habit Name", text: $habit.name)
                        Stepper("Streak Goal: \(habit.goal)", value: $habit.goal, in: 1...100)
                    }

                    Section(header: Text("Notifications")) {
                        Toggle("Enable Notifications", isOn: $enableNotification)
                        if enableNotification {
                            DatePicker("Reminder Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                        }
                    }
                }
                
                Button(action: {
                    habit.notify = enableNotification
                    habit.notificationTime = notificationTime
                    viewModel.updateHabit(habit)
                    presentationMode.wrappedValue.dismiss() // Close Edit View
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding()
                // Delete Habit Button
                               Button(action: {
                                   viewModel.deleteHabit(habit: habit)
                                   presentationMode.wrappedValue.dismiss() // Close Edit View after deletion
                               }) {
                                   Text("Delete Habit")
                                       .frame(maxWidth: .infinity)
                                       .padding()
                                       .background(Color.red)
                                       .foregroundColor(.white)
                                       .cornerRadius(10)
                                       .shadow(radius: 3)
                               }
                               .padding()
                           
            }
            .navigationTitle("Edit Habit")
        }
    }
}
