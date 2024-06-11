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
    var finishedExecution = false
    var executionVisitor: ExecutionVisitor
    
    init(codeBlock: CodeBlock = CodeBlock(), world: World = World(width: 6, length: 6)) {
        self.codeBlock = codeBlock
        self.world = world
        self.executionVisitor = ExecutionVisitor(world: world)
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
    
    func next() -> (any Instruction)? {
        if executionVisitor.endExecution || finishedExecution {
            return nil
        } else {
            guard let instruction = codeBlock.next() else {
                finishedExecution = true
                return nil
            }
            
            instruction.accept(visitor: executionVisitor)
            return instruction
        }
    }
    
    func reset() {
        //TODO: CLEAN ALL CODEBLOCKS
        codeBlock.executionIndex = 0
        world.resetWorld()
        self.executionVisitor = ExecutionVisitor(world: world)
        self.finishedExecution = false
    }
}
