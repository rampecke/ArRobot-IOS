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
    
    override func accept(visitor: any Visitor) {
        visitor.visit(ifInstruction: self)
    }
}
