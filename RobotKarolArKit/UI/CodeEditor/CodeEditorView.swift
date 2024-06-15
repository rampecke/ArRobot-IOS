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
               CodeBlockView(viewModel: viewModel)
           }, bottom: {
               ScrollView {
                   LazyVGrid(columns: columns, spacing: 10) {
                       ForEach($viewModel.allStatements, id: \.id) { $instruction in
                           InstructionAddTile(instruction: instruction).frame(height: 100).onTapGesture(perform: {
                               viewModel.createNewInstruction(instruction: instruction)
                           })
                       }
                       ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
                           InstructionAddTile(instruction: instruction).frame(height: 100).onTapGesture(perform: {
                               viewModel.createNewInstruction(instruction: instruction)
                           }).onDrag({ NSItemProvider(object: instruction.id.uuidString as NSString) })
                       }
                   }.padding()
               }
           }).fraction(fraction)
               .constraints(minPFraction: 0.4, minSFraction: 0.15)
               .styling(color: Color("card_border"))
       }, right: {
           Group {
               if viewModel.arType == ARType.AR {
                   ARSimulator(viewModel: viewModel)
               } else {
                   NonArView(viewModel: viewModel)
               }
           }
       }).fraction(fraction2)
            .constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
            .styling(color: Color("card_border"))
            .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    return CodeEditorView()
}
