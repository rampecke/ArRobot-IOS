//
//  AddInstructionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class AddInstructionVisitor: Visitor {
    private var wasAdded: Bool = false
    var targetId: UUID
    var instruction: any Instruction
    
    init(targetId: UUID, instruction: any Instruction) {
        self.targetId = targetId
        self.instruction = instruction
    }
    
    func getWasAdded() -> Bool {
        return wasAdded;
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {}
    
    func visit(rightTurn: RightTurn) {}
    
    func visit(lift: Lift) {}
    
    func visit(step: Step) {}
    
    func visit(placeGrass: PlaceGrass) {}
    
    func visit(placeStone: PlaceStone) {}
    
    func visit(placeWater: PlaceWater) {}
    
    //ControllFlow
    func visit(codeBlock: CodeBlock) {
        addToCodeBlock(codeBlock: codeBlock)
    }
    
    func visit(ifInstruction: If) {
        addToCodeBlock(codeBlock: ifInstruction)
    }
    
    func visit(whileInstruction: While) {
        addToCodeBlock(codeBlock: whileInstruction)
    }
    
    private func addToCodeBlock(codeBlock: CodeBlock) {
        if codeBlock.containsInstruction(id: targetId) {
            codeBlock.addInstructionAbove(uuid: targetId, instruction: self.instruction)
            wasAdded = true
        } else {
            for instruction in codeBlock.codeBlock {
                instruction.accept(visitor: self)
                if wasAdded { break }
            }
        }
    }
    
    //Expressions
    func visit(isEast: IsEast) {}
    
    func visit(isNorth: IsNorth) {}
    
    func visit(isSouth: IsSouth) {}
    
    func visit(isWest: IsWest) {}
    
    func visit(isBorder: IsBorder) {}
    
    func visit(isBlock: IsBlock) {}
    
    func visit(emptyExpression: EmptyExpression) {}
    
    func visit(and: And) {}
    
    func visit(or: Or) {}
    
    func visit(not: Not) {}
}

