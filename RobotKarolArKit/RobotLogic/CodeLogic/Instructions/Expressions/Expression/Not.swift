//
//  Not.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

@Observable
class Not: Expression {
    var content: Expression
    
    override init(id: UUID = UUID()) {
        self.content = EmptyExpression()
        super.init(id: id)
        self.type = "not"
    }
    
    init(content: Expression = EmptyExpression(), id: UUID = UUID()) {
        self.content = content
        super.init(id: id)
        self.type = "not"
    }
    
    //Also persist expressions
    override func asExpressionDTO() -> ExpressionDTO {
        return ExpressionDTO(id: id, type: type, content: content.asExpressionDTO())
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
