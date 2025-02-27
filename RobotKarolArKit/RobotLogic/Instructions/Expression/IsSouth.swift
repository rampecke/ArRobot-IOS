//
//  IsSouth.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class IsSouth: Expression {
    var id: UUID = UUID()
    
    func accept(visitor: Visitor) {
        visitor.visit(isSouth: self)
    }
}
