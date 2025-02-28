//
//  EmptyExpression.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import Foundation
class EmptyExpression: Expression {
    override func accept(visitor: any Visitor) {
        visitor.visit(emptyExpression: self)
    }
    
}
