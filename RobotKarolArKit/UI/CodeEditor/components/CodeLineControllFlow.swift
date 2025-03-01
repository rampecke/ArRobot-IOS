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
                    .if(viewModel.draggingInstruction) { view in
                            view.onDrop(of: [.text], isTargeted: nil) { providers in
                                viewModel.resetDraggingStates()
                                return viewModel.handleDrop(providers: providers, targetInstructionID: instruction.id, codeBlock: nil)
                            }
                        }
                
                //Only show this if instruction is If or While
                if let ifInstruction = instruction as? If {
                    ExpressionLine(expression: ifInstruction.expression, viewModel: viewModel)
                } else if let whileInstruction = instruction as? While {
                    ExpressionLine(expression: whileInstruction.expression, viewModel: viewModel)
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
            .onDrag {
                viewModel.draggingInstruction = true
                viewModel.draggingExpression = false
                
                return viewModel.dragItem(for: instruction, suggestedName: DragItemType.instruction.rawValue)
            }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    return ScrollView {
        ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }.padding()
}
