//
//  CodeEditorViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeEditorViewModel {
    var codeBlock: CodeBlock = CodeBlock()
    var allStatements: [any Instruction] = [Step(), Lift(), RightTurn(), LeftTurn(), PlaceGrass(), PlaceStone(), PlaceWater()]
    var world = World(width: 6, length: 6)
    var executionPointer: UUID
    
    init(codeBlock: CodeBlock = CodeBlock(), world: World = World(width: 6, length: 6)) {
        self.codeBlock = codeBlock
        self.world = world
        self.executionPointer = codeBlock.id
    }
    
    private func addInstruction(instruction: any Instruction) {
        codeBlock.addInstruction(instruction: instruction)
    }
    
    func createNewInstruction(instruction: any Instruction) {
        let newInstructionVisitor = NewInstructionVisitor()
        instruction.accept(visitor: newInstructionVisitor)
        addInstruction(instruction: newInstructionVisitor.get())
    }
    
    func deleteInstruction(at offsets: IndexSet) {
        codeBlock.codeBlock.remove(atOffsets: offsets)
    }
    
    func moveInstruction(from source: IndexSet, to destination: Int) {
        codeBlock.codeBlock.move(fromOffsets: source, toOffset: destination)
    }
}
