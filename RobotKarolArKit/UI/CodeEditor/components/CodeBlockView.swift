//
//  CodeBlockView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import SwiftUI

struct CodeBlockView: View {
    @Bindable var codeBlock: CodeBlock
    
    var body: some View {
        List{
            ForEach($codeBlock.codeBlock, id: \.id) { $instruction in
                if let controlFlow = instruction as? ControllFlow {
                    CodeLineControllFlow()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                } else {
                    CodeLine(instruction: instruction, CodeLineType.CodeLine)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .onDelete(perform: { indexSet in
                codeBlock.deleteInstruction(at: indexSet)
            })
            .onMove(perform: { indices, newOffset in
                codeBlock.moveInstruction(from: indices, to: newOffset)
            })
        }.listRowSpacing(10).scrollContentBackground(.hidden)
    }
}

#Preview {
    @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    viewModel.allStatements.forEach{
        viewModel.createNewInstruction(instruction: $0)
    }
    viewModel.allControllFlow.forEach{
        viewModel.createNewInstruction(instruction: $0)
    }
    return CodeBlockView(codeBlock: viewModel.codeBlock)
}
