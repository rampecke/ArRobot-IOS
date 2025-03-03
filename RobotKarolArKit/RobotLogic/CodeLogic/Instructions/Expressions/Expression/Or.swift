//
//  Or.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

@Observable
class Or: Expression {
    var left: Expression
    var right: Expression
    
    override init() {
        self.left = EmptyExpression()
        self.right = EmptyExpression()
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.left = try container.decode(Expression.self, forKey: .left)
        self.right = try container.decode(Expression.self, forKey: .right)
        try super.init(from: decoder) // Call the superclass decoder
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(left, forKey: .left)
        try container.encode(right, forKey: .right)
        try super.encode(to: encoder) // Call the superclass encoder
    }

    private enum CodingKeys: String, CodingKey {
        case left, right
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(or: self)
    }
}
