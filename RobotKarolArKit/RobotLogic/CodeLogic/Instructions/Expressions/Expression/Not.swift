//
//  Not.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class Not: Expression {
    var content: Expression
    
    override init() {
        self.content = EmptyExpression()
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(Expression.self, forKey: .content)
        try super.init(from: decoder) // Call the superclass decoder
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try super.encode(to: encoder) // Call the superclass encoder
    }

    private enum CodingKeys: String, CodingKey {
        case content
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(not: self)
    }
}
