//
//  If.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import Foundation

@Observable
class If: CodeBlock {
    var expression: Expression = EmptyExpression()
    
    override init(_ codeBlock: [Statement]?) {
        super.init(codeBlock)
        self.executionIndex = -1  // Ensure execution starts at -1 for If statements
        self.type = "ifStatement"
    }

    override init() {
        super.init()
        self.executionIndex = -1
        self.type = "ifStatement"
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
    
    override func accept(visitor: any Visitor) {
        visitor.visit(ifInstruction: self)
    }
}
