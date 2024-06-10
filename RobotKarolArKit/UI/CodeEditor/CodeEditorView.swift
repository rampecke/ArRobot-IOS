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
    let fraction = FractionHolder.usingUserDefaults(0.66, key: "myFraction")
    let fraction2 = FractionHolder.usingUserDefaults(0.5, key: "myFraction2")
    
    @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()

    
    var body: some View {
       HSplit(left: {
           VSplit(top: {
               List{
                   ForEach($viewModel.codeBlock.codeBlock, id: \.id) { $instruction in
                       CodeLine(instruction: instruction, CodeLineType.CodeLine)
                           .listRowSeparator(.hidden)
                           .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 0))
                   }.onDelete(perform: { indexSet in
                       viewModel.deleteInstruction(at: indexSet)
                   })
                   .onMove(perform: { indices, newOffset in
                       viewModel.moveInstruction(from: indices, to: newOffset)
                   })
               }.listRowSpacing(10).scrollContentBackground(.hidden)
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
           }).fraction(fraction)
               .constraints(minPFraction: 0.4, minSFraction: 0.15)
               .styling(color: Color("card_border"))
       }, right: {
           Color("card_background")
       }).fraction(fraction2)
            .constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
            .styling(color: Color("card_border"))
            .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    CodeEditorView()
}
