//
//  RobotKarolArKitApp.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import SwiftUI

@main
struct RobotKarolArKitApp: App {
    @State var model: Model = Model()
    
    var body: some Scene {
        WindowGroup {
            ProjectHomeScreen()
                .environment(model)
                .onOpenURL { url in
                    model.importProjectFromFile(url: url)
                }
        }
    }
}
