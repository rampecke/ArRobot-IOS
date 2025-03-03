//
//  NameVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 08.06.24.
//

import Foundation

class NameVisitor: Visitor {
    private var name: String = "";
    
    func get() -> String {
        return name;
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {
        self.name = "turnLeft"
    }
    
    func visit(rightTurn: RightTurn) {
        self.name = "turnRight"
    }
    
    func visit(lift: Lift) {
        self.name = "lift"
    }
    
    func visit(step: Step) {
        self.name = "step"
    }
    
    func visit(placeGrass: PlaceGrass) {
        self.name = "placeGrass"
    }
    
    func visit(placeStone: PlaceStone) {
        self.name = "placeStone"
    }
    
    func visit(placeWater: PlaceWater) {
        self.name = "placeWater"
    }
    
    //ControllFlow
    func visit(codeBlock: CodeBlock) {
        self.name = "codeBlock"
    }
    
    func visit(ifInstruction: If) {
        self.name = "if"
    }
    
    func visit(whileInstruction: While) {
        self.name = "while"
    }
    
    //Expressions
    func visit(isEast: IsEast) {
        self.name = "isEast"
    }
    
    func visit(isNorth: IsNorth) {
        self.name = "isNorth"
    }
    
    func visit(isSouth: IsSouth) {
        self.name = "isSouth"
    }
    
    func visit(isWest: IsWest) {
        self.name = "isWest"
    }
    
    func visit(isBorder: IsBorder) {
        self.name = "isBorder"
    }
    
    func visit(isBlock: IsBlock) {
        self.name = "isBlock"
    }
    
    func visit(emptyExpression: EmptyExpression) {
        self.name = "emptyExpression"
    }
    
    func visit(and: And) {
        self.name = "and"
    }
    
    func visit(or: Or) {
        self.name = "or"
    }
    
    func visit(not: Not) {
        self.name = "not"
    }
}
