//
//  IsBorder.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class IsBorder: Expression {
    var id: UUID = UUID()
    
    func accept(visitor: Visitor) {
        visitor.visit(isBorder: self)
    }
}
