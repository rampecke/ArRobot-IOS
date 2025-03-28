//
//  LeftTurn.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class LeftTurn: Statement {
    override init(id: UUID = UUID()) {
        super.init(id: id)
        self.type = "leftTurn"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(leftTurn: self)
    }
}
