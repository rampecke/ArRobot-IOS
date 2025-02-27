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
    
    func addInstruction(instruction: any Instruction) {
        codeBlock.append(instruction)
    }
    
    func addInstructionAtPosition(instruction: any Instruction, position: Int) {
        codeBlock.insert(instruction, at: position)
    }
    
    func containsInstruction(id: UUID) -> Bool {
        return codeBlock.contains { $0.id == id }
    }
    
    func getFirstInstructionWithID(uuid: UUID) -> (any Instruction)? {
        return codeBlock.first { $0.id == uuid }
    }
    
    func addInstructionAbove(uuid: UUID, instruction: any Instruction) {
        guard let position = codeBlock.firstIndex(where: { $0.id == uuid }) else {
            return
        }
        
        addInstructionAtPosition(instruction: instruction, position: position)
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
