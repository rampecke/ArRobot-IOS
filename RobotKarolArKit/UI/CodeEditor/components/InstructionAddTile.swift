//
//  InstructionAddTile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.06.24.
//

import SwiftUI

struct InstructionAddTile: View {
    var nameOfInstruction: String
    var instruction: any Instruction
    
    init(instruction: any Instruction) {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        self.nameOfInstruction = nameVisitor.get()
        self.instruction = instruction
    }
    
    func getColor(_ nameOfInstruction: String, _ ending: ColorEnding) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)\(ending.rawValue)") {
            return Color(uiColor)
        } else {
            if ending == .onPrimary {
                return Color.black
            } else {
                return Color.gray
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(nameOfInstruction)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                CodeLine(instruction: self.instruction, CodeLineType.PreviewCodeLine)
                HStack {
                    Group {
                        Text(LocalizedStringKey(nameOfInstruction + "_description"))
                            .padding(3)
                            .foregroundColor(getColor(nameOfInstruction, .onPrimary))
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color("contrast_color").opacity(0.5))
                        .cornerRadius(3)
                        .padding(3)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(getColor(nameOfInstruction, .primary))
                    .cornerRadius(5)
            }
        }.padding(5)
        .background(Color("card_background"))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
            .stroke(Color("card_border"), lineWidth: 1)
        )
    }
}

#Preview {
    ScrollView {
        InstructionAddTile(instruction: Step()).frame(height: 100)
        InstructionAddTile(instruction: Step()).frame(height: 100).environment(\.locale, .init(identifier: "en")).frame(height:100)
    }
}
