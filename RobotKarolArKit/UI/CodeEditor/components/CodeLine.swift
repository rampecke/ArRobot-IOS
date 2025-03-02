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
    let instructionColorHelper: InstructionColorNameHelper = InstructionColorNameHelper()
    
    init(instruction: Instruction, _ codeLineType: CodeLineType?) {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        self.nameOfInstruction = nameVisitor.get()
        self.codeLineType = codeLineType ?? CodeLineType.CodeLine
    }
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(nameOfInstruction))
                .foregroundColor(instructionColorHelper.getColor(nameOfInstruction, .onPrimary))
                .font(.system(size: codeLineType == CodeLineType.PreviewCodeLine ? 16 : 20, weight: .semibold, design: .rounded))
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(instructionColorHelper.getColor(nameOfInstruction, .primary))
        .clipShape(
         .rect(
             topLeadingRadius: 5,
             bottomLeadingRadius: 5,
             bottomTrailingRadius: 5,
             topTrailingRadius: 5
         )
        )
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    ScrollView {
        ForEach($viewModel.allStatements, id: \.id) { $instruction in
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
                            .environment(\.locale, .init(identifier: "en"))
        }
        ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
                            .environment(\.locale, .init(identifier: "en"))
        }
        ForEach($viewModel.allExpressions, id: \.id) { $instruction in
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
            CodeLine(instruction: instruction, CodeLineType.CodeLine)
                            .environment(\.locale, .init(identifier: "en"))
        }
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
