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
    var allControllFlow: [any Instruction] = [If(), While()]
    var world = World(width: 6, length: 6)
    var finishedExecution = false
    var executionVisitor: ExecutionVisitor
    var executionSpeed = 1.0
    var arType: ARType = ARType.AR
    
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
    
    func addInstructionToPosition(instruction: any Instruction, position: Int) {
        let newInstructionVisitor = NewInstructionVisitor()
        instruction.accept(visitor: newInstructionVisitor)
        codeBlock.addInstructionAtPosition(instruction: newInstructionVisitor.get(), position: position)
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
        executeNextStep()
    }

    private func executeNextStep() {
        // Check the stopping conditions
        guard !executionVisitor.endExecution && !finishedExecution else {
            return
        }
        
        // Execute the next step
        next()
        
        // dispatchTime 2 seconds from now:
        let dispatchTime: DispatchTime = DispatchTime.now() + executionSpeed
        // Schedule the next step after 1 second
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.executeNextStep()
        }
    }
    func reset() {
        //TODO: CLEAN ALL CODEBLOCKS
        codeBlock.executionIndex = 0
        world.resetWorld()
        self.executionVisitor = ExecutionVisitor(world: world)
        self.finishedExecution = false
    }
    
    func resetCode() {
        codeBlock.codeBlock = []
    }
    
    func switchAr() {
        switch arType {
        case .AR:
            arType = .NonAR
        case .NonAR:
            arType = .AR
        }
        
        reset()
    }
}

enum ARType {
    case AR
    case NonAR
}
