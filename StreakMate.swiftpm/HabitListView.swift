

import SwiftUI

struct HabitListView: View {
    @ObservedObject var viewModel: HabitViewModel
    @State private var newHabitName = ""
    @State private var selectedHabit: Habit?
    @State private var showEditSheet = false
    @State private var enableNotification = false
    @State private var notificationTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // TextField for adding a habit
                TextField("Enter new habit", text: $newHabitName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                
                // Toggle for enabling notification
                Toggle("Enable Notification", isOn: $enableNotification)
                    .padding(.horizontal)
                
                // Time Picker (only if notification is enabled)
                if enableNotification {
                    DatePicker("Reminder Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                        .padding(.horizontal)
                }
                
                // Add Habit Button
                Button(action: {
                    if !newHabitName.isEmpty {
                        withAnimation {
                            viewModel.addHabit(name: newHabitName, notify: enableNotification, notificationTime: notificationTime)
                            newHabitName = ""
                            enableNotification = false
                            notificationTime = Date()
                        }
                    }
                }) {
                    Text("Add Habit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                
                // Sorting Picker
                Picker("Sort by", selection: $viewModel.sortOption) {
                    Text("Name").tag(SortOption.name)
                    Text("Streak").tag(SortOption.streak)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Habit List
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.sortedHabits) { habit in
                            HabitCardView(habit: habit, viewModel: viewModel)
                                .onTapGesture {
                                    selectedHabit = habit
                                    showEditSheet = true
                                }
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("StreakMate")
            .sheet(item: $selectedHabit) { habit in
                EditHabitView(habit: habit, viewModel: viewModel)
            }
        }
    }
}
   
struct HabitCardView: View {
    var habit: Habit
    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(.primary) // Adapts to light/dark mode
                    .lineLimit(1)

                Spacer()
                
                if habit.notify {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                        .font(.title3)
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.incrementStreak(for: habit)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                        .padding(6)
                        .background(Circle().fill(Color(.systemBackground)))
                        .shadow(radius: 3)
                }
            }
            .padding(.horizontal)

            ProgressView(value: Double(habit.streak), total: Double(habit.goal))
                .progressViewStyle(LinearProgressViewStyle(tint: habit.streak >= habit.goal ? .green : .blue))
                .padding(.horizontal)

            HStack {
                Text("Streak: \(habit.streak) / \(habit.goal) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                NavigationLink(destination: HabitCalendarView(habit: habit)) {
                    HStack(spacing: 4) {
                        Text("View Calendar")
                        Image(systemName: "chevron.right")
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground)) // iOS-native background color
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(habit.streak >= habit.goal ? Color.green : Color.blue, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
