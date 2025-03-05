//
//  CodeBlock.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeBlock: Statement {
    var codeBlock: [Statement]
    var executionIndex = 0
    
    init(_ codeBlock: [Statement]?) {
        self.codeBlock = codeBlock ?? []
        super.init()
    }
    
    override init() {
        self.codeBlock = []
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.codeBlock = try container.decode([Statement].self, forKey: .codeBlock)
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
    
    override func accept(visitor: Visitor) {
        visitor.visit(codeBlock: self)
    }
    
    func deleteStatement(at offsets: IndexSet) {
        codeBlock.remove(atOffsets: offsets)
    }
    
    func deleteStatement(id: UUID) {
        codeBlock.removeAll(where: {$0.id == id})
    }
    
    func addStatement(statement: Statement) {
        codeBlock.append(statement)
    }
    
    func addStatementAtPosition(statement: Statement, position: Int) {
        codeBlock.insert(statement, at: position)
    }
    
    func containsStatement(id: UUID) -> Bool {
        return codeBlock.contains { $0.id == id }
    }
    
    func getFirstStatementWithID(uuid: UUID) -> Statement? {
        return codeBlock.first { $0.id == uuid }
    }
    
    func addStatementAbove(uuid: UUID, statement: Statement) {
        guard let position = codeBlock.firstIndex(where: { $0.id == uuid }) else {
            return
        }
        
        addStatementAtPosition(statement: statement, position: position)
    }
    
    
    //When the executionIndex is bigger than the list has elements or is smaller then 0
    func nextExists() -> Bool {
        return codeBlock.count > executionIndex && executionIndex >= 0
    }
    
    func executeNext(updateExecutionVisitor: ExecutionVisitor, world: World) {
        //if my executionIndex is not out of range
        if (nextExists()) {
            let instruction = codeBlock[executionIndex]
            
            if let codeBlockInstruction = instruction as? CodeBlock {
                //Execute the next move on the CodeBlockInstruction on a new Visitor
                let executionVisitor = ExecutionVisitor(world: world)
                codeBlockInstruction.accept(visitor: executionVisitor)
                
                //Update the status of the execution to the caller visitor
                updateExecutionVisitor.endExecution = executionVisitor.endExecution
                updateExecutionVisitor.executionMessage = executionVisitor.executionMessage
                updateExecutionVisitor.lastExecuted = executionVisitor.lastExecuted
                
                if updateExecutionVisitor.endExecution {
                    return
                }
                
                //If the execution was finished on the codeBlock  then go to next else stay at this codeBlock
                if executionVisitor.finishedExecution {
                    executionIndex = executionIndex + 1
                }
                
            } else { //If it is a normal statement execute it and go to next
                instruction.accept(visitor: updateExecutionVisitor)
                executionIndex = executionIndex + 1
            }
        }
    }
}
