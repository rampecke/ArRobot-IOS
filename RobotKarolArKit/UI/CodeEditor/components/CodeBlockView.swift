//
//  CodeBlockView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import SwiftUI

struct CodeBlockView: View {
    @Bindable var codeBlock: CodeBlock
    @Bindable var viewModel: CodeEditorViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach($codeBlock.codeBlock, id: \.id) { $instruction in
                if let controlFlow = instruction as? CodeBlock {
                    CodeLineControllFlow(instruction: controlFlow, viewModel: viewModel)
                } else {
                    CodeLine(instruction: instruction, CodeLineType.CodeLine)
                        .onDrag {
                            viewModel.dragItem(for: instruction, suggestedName: DragItemType.instruction.rawValue)
                        }
                        .onDrop(of: [.text], isTargeted: nil) { providers in
                            viewModel.handleDrop(providers: providers, targetInstructionID: instruction.id, codeBlock: nil)
                       }
                }
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 20) // Make this large enough to detect drops
        }.padding(10)
        .background(Color.clear.contentShape(Rectangle())) // Ensure drop area is recognized
        .onDrop(of: [.text], isTargeted: nil) { providers in
            viewModel.handleDrop(providers: providers, targetInstructionID: nil, codeBlock: codeBlock)
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    viewModel.allStatements.forEach{
        viewModel.createNewInstruction(instruction: $0)
    }
    viewModel.allControllFlow.forEach{
        viewModel.createNewInstruction(instruction: $0)
    }
    
    return CodeBlockView(codeBlock: viewModel.codeBlock, viewModel: viewModel).padding(10)
}
