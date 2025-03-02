//
//  RightTurn.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class RightTurn: Instruction {
    override func accept(visitor: Visitor) {
        visitor.visit(rightTurn: self)
    }
}
