//
//  Or.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class Or: Expression {
    var left: Expression
    var right: Expression
    
    override init() {
        self.left = EmptyExpression()
        self.right = EmptyExpression()
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(or: self)
    }
}
