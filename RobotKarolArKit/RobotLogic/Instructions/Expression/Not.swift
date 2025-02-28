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
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(not: self)
    }
}
