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
    
    var executionIndex = 0
    
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
    
    func next() -> (any Instruction)? {
        if (codeBlock.count > executionIndex) {
            let instruction = codeBlock[executionIndex]
            executionIndex = executionIndex + 1
            return instruction
        } else {
            return nil
        }
    }
}
