//
//  While.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import Foundation

@Observable
class While: CodeBlock {
    var expression: Expression = EmptyExpression()
    
    override init(_ codeBlock: [Statement]?) {
        super.init(codeBlock)
        self.executionIndex = -1  // Ensure execution starts at -1 for If statements
        self.type = "whileStatement"
    }

    override init() {
        super.init()
        self.executionIndex = -1
        self.type = "whileStatement"
    }
    
    init(_ codeBlock: [Statement]?, expression: Expression) {
        super.init(codeBlock)
        self.executionIndex = -1  // Ensure execution starts at -1 for If statements
        self.type = "whileStatement"
        self.expression = expression
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.expression = try container.decode(Expression.self, forKey: .expression)
        try super.init(from: decoder)  // Decode parent properties
        self.executionIndex = -1  // Ensure execution starts at -1 for If statements
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(expression, forKey: .expression)
        try super.encode(to: encoder)  // Encode parent properties
    }

    private enum CodingKeys: String, CodingKey {
        case expression
    }
    
    //Also persist codeBlock, expression and executionIndex
    override func asStatementDTO() -> StatementDTO{
        return StatementDTO(id: id, type: type, codeBlock: codeBlock.map{$0.asStatementDTO()}, executionIndex: executionIndex, expression: expression.asExpressionDTO())
    }
    
    override func accept(visitor: any Visitor) {
        visitor.visit(whileInstruction: self)
    }
}
