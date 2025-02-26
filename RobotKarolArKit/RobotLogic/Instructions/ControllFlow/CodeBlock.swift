//
//  CodeBlock.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeBlock: Instruction {
    var id: UUID = UUID()
    var codeBlock: [any Instruction]
    
    var executionIndex = 0
    
    init(_ codeBlock: [any Instruction]?) {
        self.codeBlock = codeBlock ?? []
    }
    
    init() {
        self.codeBlock = []
    }
    
    func deleteInstruction(at offsets: IndexSet) {
        codeBlock.remove(atOffsets: offsets)
    }
    
    func deleteInstruction(id: UUID) {
        codeBlock.removeAll(where: {$0.id == id})
    }

    func moveInstruction(from source: IndexSet, to destination: Int) {
        codeBlock.move(fromOffsets: source, toOffset: destination)
    }
    
    func addInstruction(instruction: any Instruction) {
        codeBlock.append(instruction)
    }
    
    func addInstructionAtPosition(instruction: any Instruction, position: Int) {
        codeBlock.insert(instruction, at: position)
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(codeBlock: self)
    }
    
    func hasNext() -> Bool {
        return codeBlock.count > executionIndex
    }
    
    func next() -> (any Instruction)? {
        if (hasNext()) {
            let instruction = codeBlock[executionIndex]
            executionIndex = executionIndex + 1
            return instruction
        } else {
            return nil
        }
    }
}
