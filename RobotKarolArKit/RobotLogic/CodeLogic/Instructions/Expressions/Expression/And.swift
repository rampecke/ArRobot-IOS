//
//  And.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

@Observable
class And: Expression {
    var left: Expression
    var right: Expression
    
    override init(id: UUID = UUID()) {
        self.left = EmptyExpression()
        self.right = EmptyExpression()
        super.init(id: id)
        self.type = "and"
    }
    
    init(left: Expression = EmptyExpression(), right: Expression = EmptyExpression(), id: UUID = UUID()) {
        self.left = left
        self.right = right
        super.init(id: id)
        self.type = "and"
    }
    
    //Also persist expressions
    override func asExpressionDTO() -> ExpressionDTO {
        return ExpressionDTO(id: id, type: type, left: left.asExpressionDTO(), right: right.asExpressionDTO())
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
        visitor.visit(and: self)
    }
}
