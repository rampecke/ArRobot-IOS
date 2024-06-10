//
//  CodeLine.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 08.06.24.
//

import SwiftUI

struct CodeLine: View {
    var nameOfInstruction: String
    
    init(instruction: any Instruction) {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        self.nameOfInstruction = nameVisitor.get()
    }
    
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
        HStack {
            Text(LocalizedStringKey(nameOfInstruction))
                .foregroundColor(getColor(nameOfInstruction, .onPrimary))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
            Spacer()
        }.frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(getColor(nameOfInstruction, .primary))
        .cornerRadius(5)
    }
}

#Preview {
    ScrollView {
        CodeLine(instruction: Step())
        CodeLine(instruction: Step())
                        .environment(\.locale, .init(identifier: "en"))
    }
}

enum ColorEnding: String {
    case onPrimary = "_color_onPrimary"
    case primary = "_color_primary"
}
