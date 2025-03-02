//
//  Lift.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class Lift: Instruction {
    override func accept(visitor: Visitor) {
        visitor.visit(lift: self)
    }
}
