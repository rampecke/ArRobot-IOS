//
//  IsNorth.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class IsNorth: Expression {
    override func accept(visitor: Visitor) {
        visitor.visit(isNorth: self)
    }
}
