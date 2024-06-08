//
//  CodeLine.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 08.06.24.
//

import SwiftUI

struct CodeLine: View {
    var nameOfInstruction: String
    
    init(nameOfInstruction: String) {
        self.nameOfInstruction = nameOfInstruction
        
        print(Color("\(nameOfInstruction)_color_onPrimary"))
    }
    
    func textColor(_ nameOfInstruction: String) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)_color_onPrimary") {
            return Color(uiColor)
        } else {
            return Color.black
        }
    }
    
    func backgroundColor(_ nameOfInstruction: String) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)_color_primary") {
            return Color(uiColor)
        } else {
            return Color.gray
        }
    }
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(nameOfInstruction))
                .foregroundColor(textColor(nameOfInstruction))
            Spacer()
        }.frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(backgroundColor(nameOfInstruction))
        .cornerRadius(5)
    }
}

#Preview {
    Group {
        CodeLine(nameOfInstruction: "step")
        CodeLine(nameOfInstruction: "step")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "turnRight")
        CodeLine(nameOfInstruction: "turnRight")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "turnLeft")
        CodeLine(nameOfInstruction: "turnLeft")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "lift")
        CodeLine(nameOfInstruction: "lift")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "placeWater")
        CodeLine(nameOfInstruction: "placeWater")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "placeGrass")
        CodeLine(nameOfInstruction: "placeGrass")
                        .environment(\.locale, .init(identifier: "en"))
        CodeLine(nameOfInstruction: "placeStone")
        CodeLine(nameOfInstruction: "placeStone")
                        .environment(\.locale, .init(identifier: "en"))
    }
}
