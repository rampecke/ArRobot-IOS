//
//  CodeLineControllFlow.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import SwiftUI

struct CodeLineControllFlow: View {
    @Bindable var instruction: CodeBlock
    @Bindable var viewModel: CodeEditorViewModel
    let instructionColorHelper: InstructionColorNameHelper = InstructionColorNameHelper()
    
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey(instructionColorHelper.getNameOfInstruction(instruction: instruction)))
                    .foregroundColor(instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: instruction), .onPrimary))
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    /*.dropDestination(for: Statement.self) { items, _ in
                        viewModel.handleStatementDrop(statement: items.first ?? Step(), targetStatement: instruction)
                        return true
                    }*/
                
                //Only show this if instruction is If or While
                if let ifInstruction = instruction as? If {
                    ExpressionLine(expression: ifInstruction.expression, viewModel: viewModel)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(viewModel.executionVisitor.lastExecuted.id == ifInstruction.expression.id ? InstructionColorNameHelper().getColor("warning_color") : .clear, lineWidth: 2)
                        )
                } else if let whileInstruction = instruction as? While {
                    ExpressionLine(expression: whileInstruction.expression, viewModel: viewModel)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(viewModel.executionVisitor.lastExecuted.id == whileInstruction.expression.id ? InstructionColorNameHelper().getColor("warning_color") : .clear, lineWidth: 2)
                        )
                }
            }.if(viewModel.dragNewInstruction) { view in
                view.dropDestination(for: Statement.self) { items, _ in
                    viewModel.handleStatementDrop(statement: items.first ?? Step(), targetStatement: instruction)
                    return true
                }
            }
            
            CodeBlockView(codeBlock: instruction, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding(2)
                .background(Color("contrast_color").opacity(0.5))
                .clipShape(
                    .rect(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 5,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 5
                    )
                )
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: instruction), .primary))
            .clipShape(
                .rect(
                    topLeadingRadius: 5,
                    bottomLeadingRadius: 5,
                    bottomTrailingRadius: 5,
                    topTrailingRadius: 5
                )
            )
            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
            .draggable(instruction) {
                CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
                    .onAppear {
                        viewModel.dragExistingInstruction()
                    }
                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
            }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    viewModel.allControllFlow.first?.addStatement(statement: Step())
    viewModel.allControllFlow.first?.addStatement(statement: Step())
    viewModel.allControllFlow.first?.addStatement(statement: Step())
    return ScrollView {
        ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }.padding()
}
