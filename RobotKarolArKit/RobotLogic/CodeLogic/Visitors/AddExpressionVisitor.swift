//
//  AddExpressionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import Foundation

class AddExpressionVisitor: Visitor {
    private var wasAdded: Bool = false
    //Target where to add
    var targetId: UUID
    //Expression to add at target
    var expression: Expression
    
    init(targetId: UUID, expression: Expression) {
        self.targetId = targetId
        self.expression = expression
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
        if ifInstruction.expression.id == targetId {
            replaceOrInsertExpression(target: &ifInstruction.expression, newExpression: expression)
        } else {
            ifInstruction.expression.accept(visitor: self)
        }
        
        if !wasAdded { //If it was not added to our expression we need to check rest
            addToCodeBlock(codeBlock: ifInstruction)
        }
    }
    
    func visit(whileInstruction: While) {
        if whileInstruction.expression.id == targetId {
            replaceOrInsertExpression(target: &whileInstruction.expression, newExpression: expression)
        } else {
            whileInstruction.expression.accept(visitor: self)
        }
        
        if !wasAdded { //If it was not added to our expression we need to check rest
            addToCodeBlock(codeBlock: whileInstruction)
        }
    }
    
    private func addToCodeBlock(codeBlock: CodeBlock) {
        for instruction in codeBlock.codeBlock {
            instruction.accept(visitor: self)
            if wasAdded { break }
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
    
    func visit(and: And) {
        if and.left.id == targetId {
            replaceOrInsertExpression(target: &and.left, newExpression: expression)
        } else if and.right.id == targetId {
            replaceOrInsertExpression(target: &and.right, newExpression: expression)
        } else {
            and.left.accept(visitor: self)
            and.right.accept(visitor: self)
        }
    }
    
    func visit(or: Or) {
        if or.left.id == targetId {
            replaceOrInsertExpression(target: &or.left, newExpression: expression)
        } else if or.right.id == targetId {
            replaceOrInsertExpression(target: &or.right, newExpression: expression)
        } else {
            or.left.accept(visitor: self)
            or.right.accept(visitor: self)
        }
    }
    
    func visit(not: Not) {
        if not.content.id == targetId {
            replaceOrInsertExpression(target: &not.content, newExpression: expression)
        } else {
            not.content.accept(visitor: self)
        }
    }
    
    private func replaceOrInsertExpression(target: inout Expression, newExpression: Expression) {
        if target is EmptyExpression {
            // Directly replace an EmptyExpression
            target = newExpression
            wasAdded = true
        } else if let andExpression = newExpression as? And {
            // If newExpression is an And, set its left to the current target and replace it
            andExpression.left = target
            target = andExpression
            wasAdded = true
        } else if let orExpression = newExpression as? Or {
            // If newExpression is an Or, set its left to the current target and replace it
            orExpression.left = target
            target = orExpression
            wasAdded = true
        } else if let notExpression = newExpression as? Not {
            // If newExpression is a Not, set its content to the current target and replace it
            notExpression.content = target
            target = notExpression
            wasAdded = true
        } else {
            // Otherwise, wrap the target inside a new And expression
            let addAnd = And()
            addAnd.left = target
            addAnd.right = newExpression
            target = addAnd
            wasAdded = true
        }
    }
}
