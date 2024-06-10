//
//  CodeEditorViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeEditorViewModel {
    var codeBlock: CodeBlock = CodeBlock()
    var allStatements: [any Instruction] = [Step(), Lift(), RightTurn(), LeftTurn(), PlaceGrass(), PlaceStone(), PlaceWater()]
    
    init() {
        codeBlock.addInstruction(instruction: Step())
        codeBlock.addInstruction(instruction: Lift())
    }
    
    func addInstruction(instruction: any Instruction) {
        codeBlock.addInstruction(instruction: instruction)
    }
    
    func createNewInstruction() {
        
    }
}
