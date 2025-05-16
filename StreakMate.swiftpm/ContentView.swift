
import SwiftUI

struct ContentView: View {
    @StateObject private var sharedViewModel = HabitViewModel()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "onboardingCompleted")

    var body: some View {
        if showOnboarding {
            OnboardingView(showOnboarding: $showOnboarding)
        } else {
            TabView {
                HabitListView(viewModel: sharedViewModel)
                    .tabItem {
                        Label("Habits", systemImage: "list.bullet")
                    }
                StreakProgressView(viewModel: sharedViewModel)
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar")
                    }
            }
        }
    }
}


