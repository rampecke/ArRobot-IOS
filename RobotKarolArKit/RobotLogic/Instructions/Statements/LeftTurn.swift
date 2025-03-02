//
//  LeftTurn.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class LeftTurn: Instruction {
    override func accept(visitor: Visitor) {
        visitor.visit(leftTurn: self)
    }
}
