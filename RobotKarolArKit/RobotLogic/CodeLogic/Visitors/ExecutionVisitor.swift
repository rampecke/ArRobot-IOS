//
//  ExecutionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 11.06.24.
//

import Foundation

@Observable
class ExecutionVisitor: Visitor {
    var world: World
    var endExecution: Bool = false
    var executionMessage: String? = nil
    var finishedExecution = false
    var lastExecuted: (any Instruction) = Step()
    
    init(world: World) {
        self.world = world
    }
    
    func setExecutionMessage(for type: String) {
        if endExecution {
            executionMessage = "\(type)_error_message"
        }
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {
        endExecution = !world.turnLeft()
        
        setExecutionMessage(for: "turnLeft")
        
        lastExecuted = leftTurn
    }
    
    func visit(rightTurn: RightTurn) {
        endExecution = !world.turnRight()
        
        setExecutionMessage(for: "turnRight")
        
        lastExecuted = rightTurn
    }
    
    func visit(lift: Lift) {
        endExecution = !world.lift()
        
        setExecutionMessage(for: "lift")
        
        lastExecuted = lift
    }
    
    func visit(step: Step) {
        endExecution = !world.step()
        
        setExecutionMessage(for: "step")
        
        lastExecuted = step
    }
    
    func visit(placeGrass: PlaceGrass) {
        endExecution = !world.place(block: BlockTyp.GRAS)
        
        setExecutionMessage(for: "placeGrass")
        
        lastExecuted = placeGrass
    }
    
    func visit(placeStone: PlaceStone) {
        endExecution = !world.place(block: BlockTyp.STONE)
        
        setExecutionMessage(for: "placeStone")
        
        lastExecuted = placeStone
    }
    
    func visit(placeWater: PlaceWater) {
        endExecution = !world.place(block: BlockTyp.WATER)
        
        setExecutionMessage(for: "placeWater")
        
        lastExecuted = placeWater
    }
    
    func visit(codeBlock: CodeBlock) {
        if endExecution {
            return
        } else {
            codeBlock.executeNext(updateExecutionVisitor: self, world: self.world)
            
            // if my codeblock has no next then and the execution has not ended
            if !codeBlock.nextExists() && !endExecution {
                self.finishedExecution = true
            }
        }
    }
    
    func visit(ifInstruction: If) {
        if endExecution {
            return
        } else {
            //if the executionIndex is -1 check the expression instead
            if ifInstruction.executionIndex == -1 {
                ifInstruction.expression.accept(visitor: self)
                lastExecuted = ifInstruction.expression
                
                //If the expression was true (finishedExecution is false then) we need to change the executionIndex
                if self.endExecution || self.finishedExecution {
                    return
                }
                ifInstruction.executionIndex = 0
            } else {
                ifInstruction.executeNext(updateExecutionVisitor: self, world: self.world)
                
                // if my codeblock has no next then and the execution has not ended then finish this codeBlock visitor
                if !ifInstruction.nextExists() && !endExecution {
                    self.finishedExecution = true
                }
            }
        }
    }
    
    func visit(whileInstruction: While) {
        if endExecution {
            return
        } else {
            //if the executionIndex is -1 check the expression instead
            if whileInstruction.executionIndex == -1 {
                whileInstruction.expression.accept(visitor: self)
                lastExecuted = whileInstruction.expression
                
                //If the expression was true (finishedExecution is false then) we need to change the executionIndex
                if self.endExecution || self.finishedExecution {
                    return
                }
                whileInstruction.executionIndex = 0
            } else {
                whileInstruction.executeNext(updateExecutionVisitor: self, world: self.world)
                
                // if my codeblock has no next then and the execution has not ended then check the expression again next
                if !whileInstruction.nextExists() {
                    whileInstruction.executionIndex = -1
                }
            }
        }
    }
    
    // Expressions (Conditions)
    func visit(isEast: IsEast) {
        finishedExecution = !world.checkRobotIsFacingDirection(direction: Direction.EAST)
    }
    
    func visit(isNorth: IsNorth) {
        finishedExecution = !world.checkRobotIsFacingDirection(direction: Direction.NORTH)
    }
    
    
    func visit(isSouth: IsSouth) {
        finishedExecution = !world.checkRobotIsFacingDirection(direction: Direction.SOUTH)
    }
    
    func visit(isWest: IsWest) {
        finishedExecution = !world.checkRobotIsFacingDirection(direction: Direction.WEST)
    }
    
    func visit(isBorder: IsBorder) {
        finishedExecution = world.nextTileExists()
    }
    
    func visit(isBlock: IsBlock) {
        finishedExecution = !world.nextTileHasBlock()
    }
    
    func visit(emptyExpression: EmptyExpression) {
        endExecution = true
        
        setExecutionMessage(for: "emptyExpression")
    }
    
    func visit(and: And) {
        let leftExpressionVisitor = ExecutionVisitor(world: self.world)
        
        if !endExecution {
            and.left.accept(visitor: leftExpressionVisitor)
            
            self.endExecution = leftExpressionVisitor.endExecution
            self.executionMessage = leftExpressionVisitor.executionMessage
        }
        
        let rightExpressionVisitor = ExecutionVisitor(world: self.world)
        if !endExecution {
            and.right.accept(visitor: rightExpressionVisitor)
            
            self.endExecution = rightExpressionVisitor.endExecution
            self.executionMessage = rightExpressionVisitor.executionMessage
        }
        
        //We need || here because finishedExecution is the oposit
        finishedExecution = leftExpressionVisitor.finishedExecution || rightExpressionVisitor.finishedExecution
    }
    
    func visit(or: Or) {
        let leftExpressionVisitor = ExecutionVisitor(world: self.world)
        if !endExecution {
            or.left.accept(visitor: leftExpressionVisitor)
            
            self.endExecution = leftExpressionVisitor.endExecution
            self.executionMessage = leftExpressionVisitor.executionMessage
        }
        
        let rightExpressionVisitor = ExecutionVisitor(world: self.world)
        if !endExecution {
            or.right.accept(visitor: rightExpressionVisitor)
            
            self.endExecution = rightExpressionVisitor.endExecution
            self.executionMessage = rightExpressionVisitor.executionMessage
        }
        
        //We need || here because finishedExecution is the oposit
        finishedExecution = leftExpressionVisitor.finishedExecution && rightExpressionVisitor.finishedExecution
    }
    func visit(not: Not) {
        let contentExpressionVisitor = ExecutionVisitor(world: self.world)
        if !endExecution {
            not.content.accept(visitor: contentExpressionVisitor)
            
            self.endExecution = contentExpressionVisitor.endExecution
            self.executionMessage = contentExpressionVisitor.executionMessage
        }
        
        finishedExecution = !contentExpressionVisitor.finishedExecution
    }
}
