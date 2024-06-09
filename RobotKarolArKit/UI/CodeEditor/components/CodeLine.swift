//
//  CodeLine.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 08.06.24.
//

import SwiftUI

struct CodeLine: View {
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
        HStack {
            Text(LocalizedStringKey(nameOfInstruction))
                .foregroundColor(getColor(nameOfInstruction, .onPrimary))
                .font(.system(size: 12, weight: .semibold, design: .rounded))
            Spacer()
        }.frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(getColor(nameOfInstruction, .primary))
        .cornerRadius(5)
    }
}

#Preview {
    ScrollView {
        ForEach(INSTRUCTIONS.allCases, id:\.rawValue) { item in
            CodeLine(nameOfInstruction: item.rawValue)
            CodeLine(nameOfInstruction: item.rawValue)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }
}

enum ColorEnding: String {
    case onPrimary = "_color_onPrimary"
    case primary = "_color_primary"
}

enum INSTRUCTIONS: String, CaseIterable {
    case STEP = "step"
    case LIFT = "lift"
    case TURNRIGHT = "turnRight"
    case TURNLEFT = "turnLeft"
    case PLACESTONE = "placeStone"
    case PLACEGRASS = "placeGrass"
    case PLACEWATER = "placeWater"
}
