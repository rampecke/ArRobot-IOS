//
//  AddExpressionIntoEmptyVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

class AddExpressionIntoEmptyVisitor: Visitor {
    //First we need to find the nextEmptyExpression and then use its ID with a addExpressionVisitor
    var wasFound = false
    var expressionToAdd: Expression
    
    init(expressionToAdd: Expression) {
        self.expressionToAdd = expressionToAdd
    }
    
    func visit(leftTurn: LeftTurn) {}
    func visit(rightTurn: RightTurn) {}
    func visit(lift: Lift) {}
    func visit(step: Step) {}
    func visit(placeGrass: PlaceGrass) {}
    func visit(placeStone: PlaceStone) {}
    func visit(placeWater: PlaceWater) {}
    
    func visit(codeBlock: CodeBlock) {
        findInCodeBlock(codeBlock: codeBlock)
    }
    
    func visit(ifInstruction: If) {
        if ifInstruction.expression is EmptyExpression {
            addExpression(targetExpression: ifInstruction.expression, acceptor: ifInstruction)
        } else {
            ifInstruction.expression.accept(visitor: self)
        }
        
        if !wasFound { //If it was not added to our expression we need to check rest
            findInCodeBlock(codeBlock: ifInstruction)
        }
    }
    
    func visit(whileInstruction: While) {
        if whileInstruction.expression is EmptyExpression {
            addExpression(targetExpression: whileInstruction.expression, acceptor: whileInstruction)
        } else {
            whileInstruction.expression.accept(visitor: self)
        }
        
        if !wasFound { //If it was not added to our expression we need to check rest
            findInCodeBlock(codeBlock: whileInstruction)
        }
    }
    
    private func findInCodeBlock(codeBlock: CodeBlock) {
        for instruction in codeBlock.codeBlock {
            instruction.accept(visitor: self)
            if wasFound{ break }
        }
    }
    
    private func addExpression(targetExpression: Expression, acceptor: any Instruction) {
        let addExpressionVisitor = AddExpressionVisitor(targetId: targetExpression.id, expression: expressionToAdd)
        acceptor.accept(visitor: addExpressionVisitor)
        wasFound = true
    }
    
    func visit(isEast: IsEast) {}
    func visit(isNorth: IsNorth) {}
    func visit(isSouth: IsSouth) {}
    func visit(isWest: IsWest) {}
    func visit(isBorder: IsBorder) {}
    func visit(isBlock: IsBlock) {}
    
    func visit(and: And) {
        if and.left is EmptyExpression {
            addExpression(targetExpression: and.left, acceptor: and)
        } else if and.right is EmptyExpression {
            addExpression(targetExpression: and.right, acceptor: and)
        } else {
            and.left.accept(visitor: self)
            and.right.accept(visitor: self)
        }
    }
    
    func visit(or: Or) {
        if or.left is EmptyExpression {
            addExpression(targetExpression: or.left, acceptor: or)
        } else if or.right is EmptyExpression {
            addExpression(targetExpression: or.right, acceptor: or)
        } else {
            or.left.accept(visitor: self)
            or.right.accept(visitor: self)
        }
    }
    
    func visit(not: Not) {
        if not.content is EmptyExpression {
            addExpression(targetExpression: not.content, acceptor: not)
        } else {
            not.content.accept(visitor: self)
        }
    }
    
    func visit(emptyExpression: EmptyExpression) {}
}
