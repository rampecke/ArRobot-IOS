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
    init() {
        _ = ArModelLoader.shared // Ensures singleton is initialized
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarWrapper()
            .environment(model)
            .onOpenURL { url in
                model.importProjectFromFile(url: url)
            }
        }
    }
}
