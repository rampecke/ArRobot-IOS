//
//  And.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class And: Expression {
    var id: UUID = UUID()
    var left: any Expression
    var right: any Expression
    
    init() {
        self.left = EmptyExpression()
        self.right = EmptyExpression()
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(and: self)
    }
}
