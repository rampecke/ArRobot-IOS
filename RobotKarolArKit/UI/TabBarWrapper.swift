//
//  TabBarWrapper.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.03.25.
//

import SwiftUI

struct TabBarWrapper: View {
    var body: some View {
        TabView {
            NavigationStack {
                ProjectHomeScreen()
            }.tabItem {
                Label("Projects", systemImage: "folder")
            }
            
            NavigationStack {
                ExerciseHomeScreen()
            }.tabItem {
                Label("Exercises", systemImage: "list.clipboard")
            }
        }
    }
}

#Preview {
    TabBarWrapper().environment(MockModel() as Model)
}
