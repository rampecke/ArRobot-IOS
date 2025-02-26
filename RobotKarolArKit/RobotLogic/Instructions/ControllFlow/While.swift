//
//  While.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import Foundation

@Observable
class While: CodeBlock {
    override func accept(visitor: any Visitor) {
        visitor.visit(whileInstruction: self)
    }
}
