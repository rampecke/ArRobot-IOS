//
//  InstructionColorNameHelper.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import Foundation
import SwiftUICore
import UIKit

struct InstructionColorNameHelper {
    //Color and Name of Instructions
    func getNameOfInstruction(instruction: any Instruction) -> String {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        return nameVisitor.get()
    }
    
    func getColor(_ nameOfInstruction: String) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)") {
            return Color(uiColor)
        } else {
            return Color.black
        }
    }
    
    func getColor(_ nameOfInstruction: String, _ ending: ColorEnding) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)\(ending.rawValue)") {
            return Color(uiColor)
        } else {
            if ending == .onPrimary {
                if let uiColor = UIColor(named: "expression\(ending.rawValue)") {
                    return Color(uiColor)
                } else {
                    return Color.black
                }
            } else {
                if let uiColor = UIColor(named: "expression\(ending.rawValue)") {
                    return Color(uiColor)
                } else {
                    return Color.gray
                }
            }
        }
    }
}
