//
//  ControllFlow.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class ControllFlow: Instruction {
    var id: UUID = UUID()
    var codeBlock: CodeBlock = CodeBlock()
    
    func accept(visitor: any Visitor) {
    }
}
