//
//  Visitable.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.03.24.
//

import Foundation

protocol Instruction: Identifiable {
    var id: UUID {get}
    
    func accept(visitor: Visitor)
}
