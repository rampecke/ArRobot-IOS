//
//  PlaceGrass.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class PlaceGrass: Instruction {
    var id: UUID = UUID()
    
    func accept(visitor: Visitor) {
        visitor.visit(placeGrass: self)
    }
}
