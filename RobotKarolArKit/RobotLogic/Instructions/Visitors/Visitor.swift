//
//  Visitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.03.24.
//

import Foundation

protocol Visitor {
    
    //Visitor classes for Instructions
    func visit(leftTurn: LeftTurn)
    func visit(rightTurn: RightTurn)
    func visit(lift: Lift)
    func visit(step: Step)
    func visit(placeGrass: PlaceGrass)
    func visit(placeStone: PlaceStone)
    func visit(placeWater: PlaceWater)
    
    //ControllFlow
    func visit(codeBlock: CodeBlock)
    func visit(ifInstruction: If)
    func visit(whileInstruction: While)
    
    //Expression
    func visit(isEast: IsEast)
    func visit(isNorth: IsNorth)
    func visit(isSouth: IsSouth)
    func visit(isWest: IsWest)
    func visit(isBorder: IsBorder)
    func visit(isBlock: IsBlock)
    func visit(expression: Expression)
    func visit(and: And)
    func visit(or: Or)
    func visit(not: Not)
    func visit(emptyExpression: EmptyExpression)
}
