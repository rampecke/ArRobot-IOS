//
//  DeleteInstructionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class DeleteStatementVisitor: Visitor {
    private var wasDeleted: Bool = false
    private var deletedStatement: Statement = Step()
    
    var deleteId: UUID
    
    init(deleteId: UUID) {
        self.deleteId = deleteId
    }
    
    func getWasDeleted() -> Bool {
        return wasDeleted;
    }
    
    func getDeletedStatement() -> Statement {
        return deletedStatement;
    }
    
    func setDeletedStatement(statement: Statement) {
        deletedStatement = statement
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
        checkCodeBlock(codeBlock: codeBlock)
    }
    
    func visit(ifInstruction: If) {
        checkCodeBlock(codeBlock: ifInstruction)
    }
    
    func visit(whileInstruction: While) {
        checkCodeBlock(codeBlock: whileInstruction)
    }
    
    private func checkCodeBlock(codeBlock: CodeBlock) {
        if codeBlock.containsStatement(id: deleteId) {
            guard let statement = codeBlock.getFirstStatementWithID(uuid: deleteId) else {
                return
            }
            deletedStatement = statement
            codeBlock.deleteStatement(id: deleteId)
            wasDeleted = true
        } else {
            for statement in codeBlock.codeBlock {
                statement.accept(visitor: self)
                if wasDeleted { break }
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
