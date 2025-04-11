//
//  ResetCodeBlockVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 05.03.25.
//

import Foundation

class ResetCodeBlockVisitor: Visitor {
    func visit(leftTurn: LeftTurn) {}
    func visit(rightTurn: RightTurn) {}
    func visit(lift: Lift) {}
    func visit(step: Step) {}
    func visit(placeGrass: PlaceGrass) {}
    func visit(placeStone: PlaceStone) {}
    func visit(placeWater: PlaceWater) {}
    
    func visit(codeBlock: CodeBlock) {
        codeBlock.executionIndex = 0
        
        for instruction in codeBlock.codeBlock {
            instruction.accept(visitor: self)
        }
    }
    
    func visit(ifInstruction: If) {
        ifInstruction.executionIndex = -1
        
        for instruction in ifInstruction.codeBlock {
            instruction.accept(visitor: self)
        }
    }
    
    func visit(whileInstruction: While) {
        whileInstruction.executionIndex = -1
        
        for instruction in whileInstruction.codeBlock {
            instruction.accept(visitor: self)
        }
    }
    
    func visit(isEast: IsEast) {}
    func visit(isNorth: IsNorth) {}
    func visit(isSouth: IsSouth) {}
    func visit(isWest: IsWest) {}
    func visit(isBorder: IsBorder) {}
    func visit(isBlock: IsBlock) {}
    func visit(and: And) {}
    func visit(or: Or) {}
    func visit(not: Not) {}
    func visit(emptyExpression: EmptyExpression) {}
    
    
}
