//
//  Expression.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

@Observable
class Expression: Instruction {
    var id: UUID = UUID()
    
    func accept(visitor: any Visitor) {
        visitor.visit(expression: self)
    }
    
}
