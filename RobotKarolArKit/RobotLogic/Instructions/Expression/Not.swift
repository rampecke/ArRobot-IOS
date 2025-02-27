//
//  Not.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class Not: Expression {
    var id: UUID = UUID()
    var content: any Expression
    
    init() {
        self.content = EmptyExpression()
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(not: self)
    }
}
