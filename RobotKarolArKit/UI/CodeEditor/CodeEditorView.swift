//
//  CodeEditorView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import SwiftUI
import SplitView

struct CodeEditorView: View {
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()

    
    var body: some View {
       HSplit(left: {
           VSplit(top: {
               List{
                   ForEach($viewModel.codeBlock.codeBlock, id: \.id) { $instruction in
                       CodeLine(instruction: instruction) .listRowSeparator(.hidden)
                   }.onDelete(perform: { indexSet in
                       viewModel.deleteInstruction(at: indexSet)
                   })
               }.listStyle(.plain)
           }, bottom: {
               ScrollView {
                   LazyVGrid(columns: columns, spacing: 10) {
                       ForEach($viewModel.allStatements, id: \.id) { $instruction in
                           InstructionAddTile(instruction: instruction).frame(height: 100).onTapGesture(perform: {
                               viewModel.createNewInstruction(instruction: instruction)
                           })
                       }
                   }.padding()
               }
           }).fraction(0.66)
               .constraints(minPFraction: 0.4, minSFraction: 0.2, dragToHideS: true)
               .styling(color: Color("card_border"))
       }, right: {
           Color.green
       }).constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
            .styling(color: Color("card_border"))
    }
}

#Preview {
    CodeEditorView()
}
