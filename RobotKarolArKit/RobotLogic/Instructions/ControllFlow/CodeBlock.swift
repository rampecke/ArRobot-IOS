//
//  CodeBlock.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeBlock: ControllFlow {
    var id: UUID = UUID()
    
    var codeBlock: [any Instruction]
    
    init(_ codeBlock: [any Instruction]?) {
        self.codeBlock = codeBlock ?? []
    }
    
    init() {
        self.codeBlock = []
    }
    
    func addInstruction(instruction: any Instruction) {
        codeBlock.append(instruction)
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(codeBlock: self)
    }
}
