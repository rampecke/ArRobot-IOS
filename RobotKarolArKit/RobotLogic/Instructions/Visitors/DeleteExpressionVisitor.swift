//
//  DeleteExpressionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import Foundation

class DeleteExpressionVisitor: Visitor {
    private var wasDeleted: Bool = false
    private var deletedExpression: Expression = EmptyExpression()
    
    //The Id of the expression we want to delete
    var deleteId: UUID
    
    init(deleteId: UUID) {
        self.deleteId = deleteId
    }
    
    func getWasDeleted() -> Bool {
        return wasDeleted;
    }
    
    func getDeletedExpression() -> Expression {
        return deletedExpression;
    }
    
    func setDeletedExpression(expression: Expression) {
        deletedExpression = expression
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
        //if we hit a ifInstruction check the Expression
        if ifInstruction.expression.id == deleteId {
            deletedExpression = ifInstruction.expression
            ifInstruction.expression = EmptyExpression()
            wasDeleted = true
        } else {
            ifInstruction.expression.accept(visitor: self)
        }
        
        if !wasDeleted { //If it was not deleted we need to check rest
            checkCodeBlock(codeBlock: ifInstruction)
        }
    }
    
    func visit(whileInstruction: While) {
        //if we hit a whileInstruction check the Expression
        if whileInstruction.expression.id == deleteId {
            deletedExpression = whileInstruction.expression
            whileInstruction.expression = EmptyExpression()
            wasDeleted = true
        } else {
            whileInstruction.expression.accept(visitor: self)
        }
        
        if !wasDeleted { //If it was not deleted we need to check rest
            checkCodeBlock(codeBlock: whileInstruction)
        }
    }
    
    //Check all the Instructions as long as it is not deleted
    private func checkCodeBlock(codeBlock: CodeBlock) {
        for instruction in codeBlock.codeBlock {
            instruction.accept(visitor: self)
            if wasDeleted { break }
        }
    }
    
    //Expressions
    func visit(isEast: IsEast) {}
    
    func visit(isNorth: IsNorth) {}
    
    func visit(isSouth: IsSouth) {}
    
    func visit(isWest: IsWest) {}
    
    func visit(isBorder: IsBorder) {}
    
    func visit(isBlock: IsBlock) {}
    
    func visit(expression: Expression) {}
    
    func visit(emptyExpression: EmptyExpression) {}
    
    func visit(and: And) {
        if and.left.id == deleteId {
            deletedExpression = and.left
            and.left = EmptyExpression()
            wasDeleted = true
        } else if and.right.id == deleteId {
            deletedExpression = and.right
            and.right = EmptyExpression()
            wasDeleted = true
        } else {
            and.left.accept(visitor: self)
            and.right.accept(visitor: self)
        }
    }
    
    func visit(or: Or) {
        if or.left.id == deleteId {
            deletedExpression = or.left
            or.left = EmptyExpression()
            wasDeleted = true
        } else if or.right.id == deleteId {
            deletedExpression = or.right
            or.right = EmptyExpression()
            wasDeleted = true
        } else {
            or.left.accept(visitor: self)
            or.right.accept(visitor: self)
        }
    }
    
    func visit(not: Not) {
        if not.content.id == deleteId {
            deletedExpression = not.content
            not.content = EmptyExpression()
            wasDeleted = true
        } else {
            not.content.accept(visitor: self)
        }
    }
}
