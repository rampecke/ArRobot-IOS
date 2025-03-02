//
//  CodeBlock.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeBlock: Instruction {
    var codeBlock: [Instruction]
    
    var executionIndex = 0
    
    init(_ codeBlock: [Instruction]?) {
        self.codeBlock = codeBlock ?? []
        super.init()
    }
    
    override init() {
        self.codeBlock = []
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.codeBlock = try container.decode([Instruction].self, forKey: .codeBlock)
        self.executionIndex = try container.decode(Int.self, forKey: .executionIndex)
        try super.init(from: decoder) // Ensure superclass is decoded
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(codeBlock, forKey: .codeBlock)
        try container.encode(executionIndex, forKey: .executionIndex)
        try super.encode(to: encoder) // Ensure superclass is encoded
    }

    private enum CodingKeys: String, CodingKey {
        case codeBlock, executionIndex
    }
    
    func deleteInstruction(at offsets: IndexSet) {
        codeBlock.remove(atOffsets: offsets)
    }
    
    func deleteInstruction(id: UUID) {
        codeBlock.removeAll(where: {$0.id == id})
    }
    
    func addInstruction(instruction: Instruction) {
        codeBlock.append(instruction)
    }
    
    func addInstructionAtPosition(instruction: Instruction, position: Int) {
        codeBlock.insert(instruction, at: position)
    }
    
    func containsInstruction(id: UUID) -> Bool {
        return codeBlock.contains { $0.id == id }
    }
    
    func getFirstInstructionWithID(uuid: UUID) -> (Instruction)? {
        return codeBlock.first { $0.id == uuid }
    }
    
    func addInstructionAbove(uuid: UUID, instruction: Instruction) {
        guard let position = codeBlock.firstIndex(where: { $0.id == uuid }) else {
            return
        }
        
        addInstructionAtPosition(instruction: instruction, position: position)
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(codeBlock: self)
    }
    
    func hasNext() -> Bool {
        return codeBlock.count > executionIndex
    }
    
    func next() -> (Instruction)? {
        if (hasNext()) {
            let instruction = codeBlock[executionIndex]
            executionIndex = executionIndex + 1
            return instruction
        } else {
            return nil
        }
    }
}
