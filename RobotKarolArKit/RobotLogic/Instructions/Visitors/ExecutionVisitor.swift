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
    
    init(world: World) {
        self.world = world
    }
    
    func visit(leftTurn: LeftTurn) {
        endExecution = !world.turnLeft()
    }
    
    func visit(rightTurn: RightTurn) {
        endExecution = !world.turnRight()
    }
    
    func visit(lift: Lift) {
        endExecution = !world.lift()
    }
    
    func visit(step: Step) {
        endExecution = !world.step()
    }
    
    func visit(placeGrass: PlaceGrass) {
        endExecution = !world.place(block: BlockTyp.GRAS)
    }
    
    func visit(placeStone: PlaceStone) {
        endExecution = !world.place(block: BlockTyp.STONE)
    }
    
    func visit(placeWater: PlaceWater) {
        endExecution = !world.place(block: BlockTyp.WATER)
    }
    
    func visit(codeBlock: CodeBlock) {
    }
}
