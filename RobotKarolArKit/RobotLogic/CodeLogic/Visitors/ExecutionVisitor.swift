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
    
    //Statements
    func visit(leftTurn: LeftTurn) {
        endExecution = !world.turnLeft()
        
        if endExecution {
            executionMessage = "It was not possible to turn left - Execution failed"
        }
        
        lastExecuted = leftTurn
    }
    
    func visit(rightTurn: RightTurn) {
        endExecution = !world.turnRight()
        
        if endExecution {
            executionMessage = "It was not possible to turn left - Execution failed"
        }
        
        lastExecuted = rightTurn
    }
    
    func visit(lift: Lift) {
        endExecution = !world.lift()
        
        if endExecution {
            executionMessage = "It was not possible to pick up a block here - Execution failed"
        }
        
        lastExecuted = lift
    }
    
    func visit(step: Step) {
        endExecution = !world.step()
        
        if endExecution {
            executionMessage = "It was not possible to make a step here - Execution failed"
        }
        
        lastExecuted = step
    }
    
    func visit(placeGrass: PlaceGrass) {
        endExecution = !world.place(block: BlockTyp.GRAS)
        
        if endExecution {
            executionMessage = "It was not possible to place a gras block here - Execution failed"
        }
        
        lastExecuted = placeGrass
    }
    
    func visit(placeStone: PlaceStone) {
        endExecution = !world.place(block: BlockTyp.STONE)
        
        if endExecution {
            executionMessage = "It was not possible to place a stone block here - Execution failed"
        }
        
        lastExecuted = placeStone
    }
    
    func visit(placeWater: PlaceWater) {
        endExecution = !world.place(block: BlockTyp.WATER)
        
        if endExecution {
            executionMessage = "It was not possible to place a water block here - Execution failed"
        }
        
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
        executionMessage = "It is not allowed to have empty conditions here - Execution failed"
    }
    
    func visit(and: And) {
        let leftExpressionVisitor = ExecutionVisitor(world: self.world)
        and.left.accept(visitor: leftExpressionVisitor)
        
        let rightExpressionVisitor = ExecutionVisitor(world: self.world)
        and.right.accept(visitor: rightExpressionVisitor)
        
        finishedExecution = leftExpressionVisitor.finishedExecution && rightExpressionVisitor.finishedExecution
    }
    
    func visit(or: Or) {
        let leftExpressionVisitor = ExecutionVisitor(world: self.world)
        or.left.accept(visitor: leftExpressionVisitor)
        
        let rightExpressionVisitor = ExecutionVisitor(world: self.world)
        or.right.accept(visitor: rightExpressionVisitor)
        
        finishedExecution = leftExpressionVisitor.finishedExecution || rightExpressionVisitor.finishedExecution
    }
    func visit(not: Not) {
        let contentExpressionVisitor = ExecutionVisitor(world: self.world)
        not.content.accept(visitor: contentExpressionVisitor)
        
        finishedExecution = !contentExpressionVisitor.finishedExecution
    }
}
