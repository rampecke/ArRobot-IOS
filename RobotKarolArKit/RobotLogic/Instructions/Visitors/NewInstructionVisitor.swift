//
//  NewInstructionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

class NewInstructionVisitor: Visitor {
    
    private var instruction: any Instruction = Step();
    
    func get() -> any Instruction {
        return instruction;
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {
        self.instruction = LeftTurn()
    }
    
    func visit(rightTurn: RightTurn) {
        self.instruction = RightTurn()
    }
    
    func visit(lift: Lift) {
        self.instruction = Lift()
    }
    
    func visit(step: Step) {
        self.instruction = Step()
    }
    
    func visit(placeGrass: PlaceGrass) {
        self.instruction = PlaceGrass()
    }
    
    func visit(placeStone: PlaceStone) {
        self.instruction = PlaceStone()
    }
    
    func visit(placeWater: PlaceWater) {
        self.instruction = PlaceWater()
    }
    
    func visit(codeBlock: CodeBlock) {
        self.instruction = CodeBlock()
    }
    
    func visit(ifInstruction: If) {
        self.instruction = If()
    }
    
    func visit(whileInstruction: While) {
        self.instruction = While()
    }
}
