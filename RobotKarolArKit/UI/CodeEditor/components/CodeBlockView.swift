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
    
    //TODO: WHEN DRAGGING THE ADD A RECTANGLE ON DROP ELSE DON'T
    var body: some View {
        VStack(spacing: 10) {
            ForEach($codeBlock.codeBlock, id: \.id) { $instruction in
                if let controlFlow = instruction as? CodeBlock {
                    CodeLineControllFlow(instruction: controlFlow, viewModel: viewModel)
                } else {
                    CodeLine(instruction: instruction, CodeLineType.CodeLine)
                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                        .draggable(instruction)
                        .dropDestination(for: Statement.self) { items, _ in
                            viewModel.handleStatementDrop(statement: items.first ?? Step(), targetStatement: instruction)
                            return true
                        }
                }
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 20) // Make this large enough to detect drops
        }.padding(10)
        .background(Color.clear.contentShape(Rectangle())) // Ensure drop area is recognized
        .dropDestination(for: Statement.self) { items, _ in
            viewModel.handleStatementDrop(statement: items.first ?? Step(), targetStatement: codeBlock, addToEndOfTarget: true)
            return true
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    viewModel.allStatements.forEach{
        viewModel.createNewStatement(statement: $0)
    }
    viewModel.allControllFlow.forEach{
        viewModel.createNewStatement(statement: $0)
    }
    
    return CodeBlockView(codeBlock: viewModel.codeBlock, viewModel: viewModel).padding(10)
}
