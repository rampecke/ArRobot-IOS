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
        ForEach($codeBlock.codeBlock, id: \.id) { $instruction in
            if let controlFlow = instruction as? CodeBlock {
                CodeLineControllFlow(instruction: controlFlow)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
            } else {
                CodeLine(instruction: instruction, CodeLineType.CodeLine)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            codeBlock.deleteInstruction(id: instruction.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .onMove(perform: { indices, newOffset in
            codeBlock.moveInstruction(from: indices, to: newOffset)
        })
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
    return List {CodeBlockView(codeBlock: viewModel.codeBlock)}.listRowSpacing(10).scrollContentBackground(.hidden).padding(10)
}
