//// OnboardingView.swift
//import SwiftUI
//
//struct OnboardingView: View {
//    @Binding var showOnboarding: Bool
//    @State private var currentPage = 0
//
//    let pages = [
//        ("Welcome to StreakMate!", "Track your daily habits and build positive streaks.", "list.bullet.rectangle"),
//        ("Add Habits", "Create habits easily and monitor your progress.", "plus.circle"),
//        ("Track Progress", "Visualize habit streaks with progress charts.", "chart.bar")
//    ]
//
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                Button(action: {
//                    showOnboarding = false
//                    UserDefaults.standard.set(true, forKey: "onboardingCompleted")
//                }) {
//                    Text("Skip")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//
//            TabView(selection: $currentPage) {
//                ForEach(0..<pages.count, id: \.self) { index in
//                    VStack {
//                        Text(pages[index].0).font(.largeTitle).bold().padding()
//                        Text(pages[index].1).multilineTextAlignment(.center).padding()
//                        Image(systemName: pages[index].2).resizable().scaledToFit().frame(height: 200).padding()
//                    }
//                    .tag(index)
//                }
//            }
//            .tabViewStyle(PageTabViewStyle())
//
//            HStack {
//                ForEach(0..<pages.count, id: \.self) { index in
//                    Circle().fill(index == currentPage ? Color.blue : Color.gray).frame(width: 10, height: 10).padding(2)
//                }
//            }
//
//            if currentPage == pages.count - 1 {
//                Button(action: {
//                    showOnboarding = false
//                    UserDefaults.standard.set(true, forKey: "onboardingCompleted")
//                }) {
//                    Text("Get Started")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//        }
//    }
//}
//
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to StreakMate!")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.blue)
                
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                    Text("Add and customize your habits")
                }
                
                HStack {
                    Image(systemName: "chart.bar.fill").foregroundColor(.blue)
                    Text("Track your progress with streaks")
                }
                
                HStack {
                    Image(systemName: "bell.fill").foregroundColor(.blue)
                    Text("Set daily reminders to stay consistent")
                }
                
                HStack {
                    Image(systemName: "calendar").foregroundColor(.blue)
                    Text("View habit calendar insights")
                }
            }
            .font(.headline)
            .padding()
            
            Spacer()
            
            Button(action: {
                showOnboarding = false
                UserDefaults.standard.set(true, forKey: "onboardingCompleted")
            }) {
                Text("Get Started")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
