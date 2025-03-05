//
//  ExecutionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 11.06.24.
//

import Foundation

class ExecutionVisitor: Visitor {
    var world: World
    var endExecution: Bool = false
    var executionMessage: String? = nil
    var finishedExecution = false
    
    init(world: World) {
        self.world = world
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {
        endExecution = !world.turnLeft()
        
        if endExecution {
            executionMessage = "It was not possible to turn left - Execution failed"
        }
    }
    
    func visit(rightTurn: RightTurn) {
        endExecution = !world.turnRight()
        
        if endExecution {
            executionMessage = "It was not possible to turn left - Execution failed"
        }
    }
    
    func visit(lift: Lift) {
        endExecution = !world.lift()
        
        if endExecution {
            executionMessage = "It was not possible to pick up a block here - Execution failed"
        }
    }
    
    func visit(step: Step) {
        endExecution = !world.step()
        
        if endExecution {
            executionMessage = "It was not to make a step here - Execution failed"
        }
    }
    
    func visit(placeGrass: PlaceGrass) {
        endExecution = !world.place(block: BlockTyp.GRAS)
        
        if endExecution {
            executionMessage = "It was not possible to place a gras block here - Execution failed"
        }
    }
    
    func visit(placeStone: PlaceStone) {
        endExecution = !world.place(block: BlockTyp.STONE)
        
        if endExecution {
            executionMessage = "It was not possible to place a stone block here - Execution failed"
        }
    }
    
    func visit(placeWater: PlaceWater) {
        endExecution = !world.place(block: BlockTyp.WATER)
        
        if endExecution {
            executionMessage = "It was not possible to place a water block here - Execution failed"
        }
    }
    
    //ControllFlow //TODO: ADD CONTROLLFLOW
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
    
    //TODO: ADD check of Expressions
    func visit(ifInstruction: If) {
        if endExecution {
            return
        } else {
            //TODO: if -1 execution index check the expression first
            ifInstruction.executeNext(updateExecutionVisitor: self, world: self.world)
            
            // if my codeblock has no next then and the execution has not ended
            //TODO: RESET to -1 first
            if !ifInstruction.nextExists() && !endExecution {
                self.finishedExecution = true
            }
        }
    }
    
    //TODO: ADD check of Expressions
    func visit(whileInstruction: While) {
        if endExecution {
            return
        } else {
            //TODO: if -1 execution index check the expression first
            whileInstruction.executeNext(updateExecutionVisitor: self, world: self.world)
            
            // if my codeblock has no next then and the execution has not ended
            //TODO: RESET to -1 first
            if !whileInstruction.nextExists() && !endExecution {
                self.finishedExecution = true
            }
        }
    }
    
    // Expressions (Conditions)
    func visit(isEast: IsEast) { handleInvalidCondition() }
    func visit(isNorth: IsNorth) { handleInvalidCondition() }
    func visit(isSouth: IsSouth) { handleInvalidCondition() }
    func visit(isWest: IsWest) { handleInvalidCondition() }
    func visit(isBorder: IsBorder) { handleInvalidCondition() }
    func visit(isBlock: IsBlock) { handleInvalidCondition() }
    func visit(expression: Expression) { handleInvalidCondition() }
    func visit(emptyExpression: EmptyExpression) { handleInvalidCondition() }
    func visit(and: And) { handleInvalidCondition() }
    func visit(or: Or) { handleInvalidCondition() }
    func visit(not: Not) { handleInvalidCondition() }
    
    private func handleInvalidCondition() {
        endExecution = true
        executionMessage = "It is not allowed to have a condition here - Execution failed"
    }
}
