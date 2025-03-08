//
//  IsSouth.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class IsSouth: Expression {
    override init(id: UUID = UUID()) {
        super.init(id: id)
        self.type = "isSouth"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(isSouth: self)
    }
}
