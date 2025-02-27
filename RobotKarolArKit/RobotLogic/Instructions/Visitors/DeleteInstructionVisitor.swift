//
//  DeleteInstructionVisitor.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation

class DeleteInstructionVisitor: Visitor {
    private var wasDeleted: Bool = false
    private var deletedInstruction: any Instruction = Step()
    
    var deleteId: UUID
    
    init(deleteId: UUID) {
        self.deleteId = deleteId
    }
    
    func getWasDeleted() -> Bool {
        return wasDeleted;
    }
    
    func getDeletedInstruction() -> any Instruction {
        return deletedInstruction;
    }
    
    func setDeletedInstruction(instruction: any Instruction) {
        deletedInstruction = instruction
    }
    
    //Statements
    func visit(leftTurn: LeftTurn) {}
    
    func visit(rightTurn: RightTurn) {}
    
    func visit(lift: Lift) {}
    
    func visit(step: Step) {}
    
    func visit(placeGrass: PlaceGrass) {}
    
    func visit(placeStone: PlaceStone) {}
    
    func visit(placeWater: PlaceWater) {}
    
    //ControllFlow
    func visit(codeBlock: CodeBlock) {
        checkCodeBlock(codeBlock: codeBlock)
    }
    
    func visit(ifInstruction: If) {
        checkCodeBlock(codeBlock: ifInstruction)
    }
    
    func visit(whileInstruction: While) {
        checkCodeBlock(codeBlock: whileInstruction)
    }
    
    private func checkCodeBlock(codeBlock: CodeBlock) {
        if codeBlock.containsInstruction(id: deleteId) {
            guard let instruction = codeBlock.getFirstInstructionWithID(uuid: deleteId) else {
                return
            }
            deletedInstruction = instruction
            codeBlock.deleteInstruction(id: deleteId)
            wasDeleted = true
        } else {
            for instruction in codeBlock.codeBlock {
                instruction.accept(visitor: self)
                if wasDeleted { break }
            }
        }
    }
}
