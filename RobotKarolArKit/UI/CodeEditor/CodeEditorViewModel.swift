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
    
    func next() {
        if executionVisitor.endExecution || finishedExecution {
            return
        } else {
            guard let instruction = codeBlock.next() else {
                finishedExecution = true
                return
            }
            
            instruction.accept(visitor: executionVisitor)
            if(!codeBlock.hasNext()) {
                finishedExecution = true
            }
        }
    }
    
    func executeAll() {
        while(!executionVisitor.endExecution && !finishedExecution) {
            next()
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
