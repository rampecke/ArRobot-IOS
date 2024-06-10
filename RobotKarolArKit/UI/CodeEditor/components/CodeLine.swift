//
//  CodeLine.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 08.06.24.
//

import SwiftUI

struct CodeLine: View {
    var nameOfInstruction: String
    var codeLineType: CodeLineType
    
    init(instruction: any Instruction, _ codeLineType: CodeLineType?) {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        self.nameOfInstruction = nameVisitor.get()
        self.codeLineType = codeLineType ?? CodeLineType.CodeLine
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
                .font(.system(size: codeLineType == CodeLineType.PreviewCodeLine ? 16 : 20, weight: .semibold, design: .rounded))
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(getColor(nameOfInstruction, .primary))
        .clipShape(
         .rect(
             topLeadingRadius: 5,
             bottomLeadingRadius: 5,
             bottomTrailingRadius: codeLineType == CodeLineType.PreviewCodeLine ? 5 : 0,
             topTrailingRadius: codeLineType == CodeLineType.PreviewCodeLine ? 5 : 0
         )
        )
    }
}

#Preview {
    ScrollView {
        CodeLine(instruction: Step(), CodeLineType.CodeLine)
        CodeLine(instruction: Step(), CodeLineType.CodeLine)
                        .environment(\.locale, .init(identifier: "en"))
    }.padding()
}

enum ColorEnding: String {
    case onPrimary = "_color_onPrimary"
    case primary = "_color_primary"
}

enum CodeLineType: String {
    case CodeLine
    case PreviewCodeLine
}
