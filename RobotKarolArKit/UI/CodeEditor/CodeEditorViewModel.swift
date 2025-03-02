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
    var allStatements: [Instruction] = [Step(), Lift(), RightTurn(), LeftTurn(), PlaceGrass(), PlaceStone(), PlaceWater()]
    var allControllFlow: [CodeBlock] = [If(), While()]
    var allExpressions: [Expression] = [IsEast(), IsWest(), IsNorth(), IsSouth(), IsBlock(), IsBorder(), And(), Or(), Not()]
    var world = World(width: 6, length: 6)
    var finishedExecution = false
    var executionVisitor: ExecutionVisitor
    var executionSpeed = 1.0
    var arType: ARType = ARType.AR
    
    var draggingExpression = false
    var draggingInstruction = false
    
    init(codeBlock: CodeBlock = CodeBlock(), world: World = World(width: 6, length: 6)) {
        self.codeBlock = codeBlock
        self.world = world
        self.executionVisitor = ExecutionVisitor(world: world)
    }
    
    func resetDraggingStates() {
        draggingExpression = false
        draggingInstruction = false
    }
    
    private func addInstruction(instruction: Instruction) {
        codeBlock.addInstruction(instruction: instruction)
    }
    
    func createNewInstruction(instruction: Instruction) {
        let newInstructionVisitor = NewInstructionVisitor()
        instruction.accept(visitor: newInstructionVisitor)
        addInstruction(instruction: newInstructionVisitor.get())
    }
    
    func addInstructionToPosition(instruction: Instruction, position: Int) {
        let newInstructionVisitor = NewInstructionVisitor()
        instruction.accept(visitor: newInstructionVisitor)
        codeBlock.addInstructionAtPosition(instruction: newInstructionVisitor.get(), position: position)
    }
    
    //TODO: USE ACCEPT OF CODEBLOCK
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
    
    //New Drag and Drop functions
    //TODO: HANDLE targetInstruction nil
    func handleInstructionDrop (instruction: Instruction, targetInstruction: Instruction, addToEndOfTarget: Bool? = nil) {
        if let instructionAsExpression = instruction as? Expression {
            if let targetInstructionAsExpression = targetInstruction as? Expression {
                let deleteExpressionVisitor = DeleteExpressionVisitor(deleteId: instructionAsExpression.id)
                
                if allExpressions.contains(where: { $0.id == instructionAsExpression.id }) {
                    let newInstructionVisitor = NewInstructionVisitor()
                    instructionAsExpression.accept(visitor: newInstructionVisitor)
                    
                    guard let newExpression = newInstructionVisitor.get() as? Expression else { return }
                    deleteExpressionVisitor.setDeletedExpression(expression: newExpression)
                } else {
                   //If it is not a new expression delete the old one
                    self.codeBlock.accept(visitor: deleteExpressionVisitor)
                }
                
                let addExpressionVisitor = AddExpressionVisitor(targetId: targetInstructionAsExpression.id, expression: deleteExpressionVisitor.getDeletedExpression())
                //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
                self.codeBlock.accept(visitor: addExpressionVisitor)
            } else {
                return
            }
        } else {
            if targetInstruction is Expression {
                return
            } else {
                let deleteInstructionVisitor = DeleteInstructionVisitor(deleteId: instruction.id)

                let allInstructions = allStatements + allControllFlow
                if let instructionType = allInstructions.first(where: { $0.id == instruction.id }) {
                    let newInstructionVisitor = NewInstructionVisitor()
                    instructionType.accept(visitor: newInstructionVisitor)
                    
                    deleteInstructionVisitor.setDeletedInstruction(instruction: newInstructionVisitor.get())
                } else {
                    self.codeBlock.accept(visitor: deleteInstructionVisitor)
                }
                
                if addToEndOfTarget ?? false {
                    guard let targetCodeBlock = targetInstruction as? CodeBlock else { return }
                    
                    targetCodeBlock.addInstruction(instruction: deleteInstructionVisitor.getDeletedInstruction())
                } else {
                    let addInstructionVisitor = AddInstructionVisitor(targetId: targetInstruction.id, instruction: deleteInstructionVisitor.getDeletedInstruction())
                    //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
                    self.codeBlock.accept(visitor: addInstructionVisitor)
                }
            }
        }
    }
}

enum ARType {
    case AR
    case NonAR
}

enum DragItemType: String {
    case instruction
    case newInstruction
    case expression
    case newExpression
}
