//
//  InstructionAddTile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.06.24.
//

import SwiftUI

struct InstructionAddTile: View {
    var nameOfInstruction: String
    
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
                CodeLine(nameOfInstruction: nameOfInstruction)
                HStack {
                    Group {
                        Text(LocalizedStringKey(nameOfInstruction + "_description"))
                            .padding(3)
                            .foregroundColor(getColor(nameOfInstruction, .onPrimary))
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.5))
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
        ForEach(INSTRUCTIONS.allCases, id:\.rawValue) { item in
            InstructionAddTile(nameOfInstruction: item.rawValue).frame(height:100)
            InstructionAddTile(nameOfInstruction: item.rawValue).environment(\.locale, .init(identifier: "en")).frame(height:100)
        }
    }
}
