//
//  EmptyExpression.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class EmptyExpression: Expression {
    var id: UUID = UUID()
    
    func accept(visitor: Visitor) {
        visitor.visit(emptyExpression: self)
    }
}
