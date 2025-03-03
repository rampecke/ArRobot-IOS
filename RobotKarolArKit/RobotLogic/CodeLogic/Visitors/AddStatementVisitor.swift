//
//  AddInstructionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class AddStatementVisitor: Visitor {
    private var wasAdded: Bool = false
    var targetId: UUID
    var statement: Statement
    
    init(targetId: UUID, statement: Statement) {
        self.targetId = targetId
        self.statement = statement
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
        if codeBlock.containsStatement(id: targetId) {
            codeBlock.addStatementAbove(uuid: targetId, statement: self.statement)
            wasAdded = true
        } else {
            for statement in codeBlock.codeBlock {
                statement.accept(visitor: self)
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

