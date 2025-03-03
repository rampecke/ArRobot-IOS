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
    var executionMessage: String = ""
    
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
        //Only perform the next Statement
    }
    
    func visit(ifInstruction: If) {
        //Only perform the next Statement
    }
    
    func visit(whileInstruction: While) {
        //Only perform the next Statement
    }
    
    //Expressions
    func visit(isEast: IsEast) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(isNorth: IsNorth) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(isSouth: IsSouth) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(isWest: IsWest) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(isBorder: IsBorder) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(isBlock: IsBlock) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(expression: Expression) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(emptyExpression: EmptyExpression) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(and: And) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(or: Or) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
    
    func visit(not: Not) {
        endExecution = true
        
        if endExecution {
            executionMessage = "It is not allowed to have a condition here - Execution failed"
        }
    }
}
