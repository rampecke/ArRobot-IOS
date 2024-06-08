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
}
