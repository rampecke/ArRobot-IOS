//
//  EmptyExpression.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import Foundation
class EmptyExpression: Expression {
    override init(id: UUID = UUID()) {
        super.init(id: id)
        self.type = "emptyExpression"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    override func accept(visitor: any Visitor) {
        visitor.visit(emptyExpression: self)
    }
    
}
