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
        self.name = "leftTurn"
    }
    
    func visit(rightTurn: RightTurn) {
        self.name = "rightTurn"
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
    
}
