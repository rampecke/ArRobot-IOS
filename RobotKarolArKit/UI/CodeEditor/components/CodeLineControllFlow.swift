//
//  CodeLineControllFlow.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import SwiftUI

struct CodeLineControllFlow: View {
    func getColor(_ nameOfInstruction: String, _ ending: ColorEnding) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)\(ending.rawValue)") {
            return Color(uiColor)
        } else {
            if ending == .onPrimary {
                return Color.black
            } else {
                return Color.gray
            }
        }
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CodeLineControllFlow()
}
