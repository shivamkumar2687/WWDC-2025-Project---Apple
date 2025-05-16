//
//  
//  swiftChallengeTest
//
//  Created by Shivam Kumar on 19/02/25.
//

// StreakProgressView.swift
import SwiftUI
import Charts


struct StreakProgressView: View {
    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        VStack {
            Text("Habit Streak Progress")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .padding(.top)

            if viewModel.habits.isEmpty {
                VStack {
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.bottom, 10)

                    Text("No habits to show. Add some habits first!")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            } else {
                Chart(viewModel.habits) { habit in
                    BarMark(
                        x: .value("Habit", habit.name),
                        y: .value("Streak", habit.streak)
                    )
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(5)
                }
                .frame(height: 250)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 3)
                )
                .padding()
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.2)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

