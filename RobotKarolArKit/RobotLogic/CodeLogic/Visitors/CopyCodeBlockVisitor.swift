//
//  CopyCodeBlockVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 12.03.25.
//

import Foundation

class CopyCodeBlockVisitor: Visitor {
    var returnInstruction: any Instruction = Step()
    
    func returnCodeBlock() -> CodeBlock {
        if let returnCodeBlock = returnInstruction as? CodeBlock {
            return returnCodeBlock
        } else {
            return CodeBlock()
        }
    }
    
    func visit(leftTurn: LeftTurn) {
        returnInstruction = LeftTurn()
    }
    
    func visit(rightTurn: RightTurn) {
        returnInstruction = RightTurn()
    }
    
    func visit(lift: Lift) {
        returnInstruction = Lift()
    }
    
    func visit(step: Step) {
        returnInstruction = Step()
    }
    
    func visit(placeGrass: PlaceGrass) {
        returnInstruction = PlaceGrass()
    }
    
    func visit(placeStone: PlaceStone) {
        returnInstruction = PlaceStone()
    }
    
    func visit(placeWater: PlaceWater) {
        returnInstruction = PlaceWater()
    }
    
    func visit(codeBlock: CodeBlock) {
        let codeBlockCopy = CodeBlock()
        
        codeBlock.codeBlock.forEach { instruction in
            let copyVisitor = CopyCodeBlockVisitor()
            instruction.accept(visitor: copyVisitor)
            
            if let instructionAsStatement = copyVisitor.returnInstruction as? Statement {
                codeBlockCopy.codeBlock.append(instructionAsStatement)
            }
        }
        
        returnInstruction = codeBlockCopy
    }
    
    func visit(ifInstruction: If) {
        let ifInstructionCopy = If()
        
        let copyExpression = CopyCodeBlockVisitor()
        ifInstruction.expression.accept(visitor: copyExpression)
        if let instructionAsExpression = copyExpression.returnInstruction as? Expression {
            ifInstructionCopy.expression = instructionAsExpression
        }
        
        ifInstruction.codeBlock.forEach { instruction in
            let copyVisitor = CopyCodeBlockVisitor()
            instruction.accept(visitor: copyVisitor)
            
            if let instructionAsStatement = copyVisitor.returnInstruction as? Statement {
                ifInstructionCopy.codeBlock.append(instructionAsStatement)
            }
        }
        
        returnInstruction = ifInstructionCopy
    }
    
    func visit(whileInstruction: While) {
        let whileInstructionCopy = If()
        
        let copyExpression = CopyCodeBlockVisitor()
        whileInstruction.expression.accept(visitor: copyExpression)
        if let instructionAsExpression = copyExpression.returnInstruction as? Expression {
            whileInstructionCopy.expression = instructionAsExpression
        }
        
        whileInstruction.codeBlock.forEach { instruction in
            let copyVisitor = CopyCodeBlockVisitor()
            instruction.accept(visitor: copyVisitor)
            
            if let instructionAsStatement = copyVisitor.returnInstruction as? Statement {
                whileInstructionCopy.codeBlock.append(instructionAsStatement)
            }
        }
        
        returnInstruction = whileInstructionCopy
    }
    
    func visit(isEast: IsEast) {
        returnInstruction = IsEast()
    }
    
    func visit(isNorth: IsNorth) {
        returnInstruction = IsEast()
    }
    
    func visit(isSouth: IsSouth) {
        returnInstruction = IsSouth()
    }
    
    func visit(isWest: IsWest) {
        returnInstruction = IsWest()
    }
    
    func visit(isBorder: IsBorder) {
        returnInstruction = IsBorder()
    }
    
    func visit(isBlock: IsBlock) {
        returnInstruction = IsBlock()
    }
    
    func visit(and: And) {
        let andCopy = And()
        
        let leftCopyVisitor = CopyCodeBlockVisitor()
        and.left.accept(visitor: leftCopyVisitor)
        if let leftExpressionCopy = leftCopyVisitor.returnInstruction as? Expression {
            andCopy.left = leftExpressionCopy
        }
        
        let rightCopyVisitor = CopyCodeBlockVisitor()
        and.right.accept(visitor: rightCopyVisitor)
        if let rightExpressionCopy = rightCopyVisitor.returnInstruction as? Expression {
            andCopy.left = rightExpressionCopy
        }
        
        returnInstruction = andCopy
    }
    
    func visit(or: Or) {
        let orCopy = Or()
        
        let leftCopyVisitor = CopyCodeBlockVisitor()
        or.left.accept(visitor: leftCopyVisitor)
        if let leftExpressionCopy = leftCopyVisitor.returnInstruction as? Expression {
            orCopy.left = leftExpressionCopy
        }
        
        let rightCopyVisitor = CopyCodeBlockVisitor()
        or.right.accept(visitor: rightCopyVisitor)
        if let rightExpressionCopy = rightCopyVisitor.returnInstruction as? Expression {
            orCopy.left = rightExpressionCopy
        }
        
        returnInstruction = orCopy
    }
    
    func visit(not: Not) {
        let notCopy = Not()
        
        let contentCopyVisitor = CopyCodeBlockVisitor()
        not.content.accept(visitor: contentCopyVisitor)
        if let contentExpressionCopy = contentCopyVisitor.returnInstruction as? Expression {
            notCopy.content = contentExpressionCopy
        }
        
        returnInstruction = notCopy
    }
    
    func visit(emptyExpression: EmptyExpression) {
        returnInstruction = EmptyExpression()
    }
    
    
}
