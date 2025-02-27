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
    
    //Statements
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
    
    //ControllFlow
    func visit(codeBlock: CodeBlock) {
    }
    
    func visit(ifInstruction: If) {
    }
    
    func visit(whileInstruction: While) {
    }
    
    //Expressions
    func visit(isEast: IsEast) {
        endExecution = true
    }
    
    func visit(isNorth: IsNorth) {
        endExecution = true
    }
    
    func visit(isSouth: IsSouth) {
        endExecution = true
    }
    
    func visit(isWest: IsWest) {
        endExecution = true
    }
    
    func visit(isBorder: IsBorder) {
        endExecution = true
    }
    
    func visit(isBlock: IsBlock) {
        endExecution = true
    }
    
    func visit(emptyExpression: EmptyExpression) {
        endExecution = true
    }
    
    func visit(and: And) {
        endExecution = true
    }
    
    func visit(or: Or) {
        endExecution = true
    }
    
    func visit(not: Not) {
        endExecution = true
    }
}
