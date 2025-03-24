//
//  NoARExecutionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 12.03.25.
//

import Foundation

class NoARExecutionVisitor: ExecutionVisitor {
    override func visit(leftTurn: LeftTurn) {
        endExecution = !world.turnLeftWithoutAR()
        
        setExecutionMessage(for: "turnLeft")
        
        lastExecuted = leftTurn
    }
    
    override func visit(rightTurn: RightTurn) {
        endExecution = !world.turnRightWithoutAR()
        
        setExecutionMessage(for: "turnRight")
        
        lastExecuted = rightTurn
    }
    
    override func visit(lift: Lift) {
        endExecution = !world.liftWithoutAR()
        
        setExecutionMessage(for: "lift")
        
        lastExecuted = lift
    }
    
    override func visit(step: Step) {
        endExecution = !world.stepWithoutAr()
        
        setExecutionMessage(for: "step")
        
        lastExecuted = step
    }
    
    override func visit(placeGrass: PlaceGrass) {
        endExecution = !world.placeWithoutAr(block: BlockTyp.GRAS)
        
        setExecutionMessage(for: "placeGrass")
        
        lastExecuted = placeGrass
    }
    
    override func visit(placeStone: PlaceStone) {
        endExecution = !world.placeWithoutAr(block: BlockTyp.STONE)
        
        setExecutionMessage(for: "placeStone")
        
        lastExecuted = placeStone
    }
    
    override func visit(placeWater: PlaceWater) {
        endExecution = !world.placeWithoutAr(block: BlockTyp.WATER)
        
        setExecutionMessage(for: "placeWater")
        
        lastExecuted = placeWater
    }
}
