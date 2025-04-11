//
//  TabBarWrapper.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.03.25.
//

import SwiftUI

struct TabBarWrapper: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView (selection: $selectedTab){
            NavigationStack {
                ProjectHomeScreen()
            }.tabItem {
                Label("Projects", systemImage: "folder")
            }.tag(0)
            
            NavigationStack {
                ExerciseHomeScreen()
            }.tabItem {
                Label("Exercises", systemImage: "list.clipboard")
            }.tag(1)
            
            NavigationStack {
                ChallengeView()
            }.tabItem {
                Label("Challenge", systemImage: "medal")
            }.tag(2)
        }.environment(\.tabBarSelection, $selectedTab)
        .environment(\.horizontalSizeClass, .compact)
        .onAppear {
            //If this app is updated to iOS18 use .toolbarVisibility instead
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    TabBarWrapper().environment(MockModel() as Model)
}

private struct TabBarSelectionKey: EnvironmentKey {
    static let defaultValue: Binding<Int>? = nil
}

extension EnvironmentValues {
    var tabBarSelection: Binding<Int>? {
        get { self[TabBarSelectionKey.self] }
        set { self[TabBarSelectionKey.self] = newValue }
    }
}
