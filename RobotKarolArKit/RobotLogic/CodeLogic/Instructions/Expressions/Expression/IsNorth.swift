//
//  IsNorth.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class IsNorth: Expression {
    override init() {
        super.init()
        self.type = "isNorth"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(isNorth: self)
    }
}
