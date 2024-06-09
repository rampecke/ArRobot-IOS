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

    
    var body: some View {
       HSplit(left: {
           VSplit(top: {
               ScrollView {
                   ForEach(INSTRUCTIONS.allCases, id: \.rawValue) { instruction in
                       CodeLine(nameOfInstruction: instruction.rawValue)
                       CodeLine(nameOfInstruction: instruction.rawValue)
                       CodeLine(nameOfInstruction: instruction.rawValue)
                       CodeLine(nameOfInstruction: instruction.rawValue)
                       CodeLine(nameOfInstruction: instruction.rawValue)
                   }
               }.padding(10)
           }, bottom: {
               ScrollView {
                   LazyVGrid(columns: columns, spacing: 10) {
                       ForEach(INSTRUCTIONS.allCases, id: \.rawValue) { instruction in
                           InstructionAddTile(nameOfInstruction: instruction.rawValue).frame(height: 100)
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
