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
    var allControllFlow: [CodeBlock] = [If(), While()]
    var allExpressions: [ Expression] = [IsEast(), IsWest(), IsNorth(), IsSouth(), IsBlock(), IsBorder(), And(), Or(), Not()]
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
    
    //TODO: Maybe HANDLE DIFFRENCE BETWEEN EXPRESSIONS AND STATEMENTS -> Don't allow Expressions Anywhere else
    //Handle Drag and Drop: Get an ID of an Element and a targetWhere to place it
    func handleDrop(providers: [NSItemProvider], targetInstructionID: UUID?, codeBlock: CodeBlock?) -> Bool {
        for provider in providers {
            provider.loadObject(ofClass: NSString.self) { object, _ in
                if let idString = object as? String, let draggedID = UUID(uuidString: idString) {
                    DispatchQueue.main.async {
                        //Make sure the itemposition is not the same
                        if draggedID == targetInstructionID {
                            return
                        }
                        
                        //If it exists then remove it from old position and add it at new position
                        //If it didn't exist create a new one
                        let deleteInstructionVisitor = DeleteInstructionVisitor(deleteId: draggedID)
                        let deleteExpressionVisitor = DeleteExpressionVisitor(deleteId: draggedID)
                        
                        if let type = DragItemType(rawValue: provider.suggestedName ?? "") {
                            switch type {
                            case .instruction:
                                self.codeBlock.accept(visitor: deleteInstructionVisitor)
                                self.processDraggedInstruction(draggedID: draggedID, targetInstructionID: targetInstructionID, codeBlock: codeBlock, deleteInstructionVisitor: deleteInstructionVisitor)
                            case .newInstruction:
                                //on an new instruction we don't need to perform the delete visit -> performance
                                self.processDraggedInstruction(draggedID: draggedID, targetInstructionID: targetInstructionID, codeBlock: codeBlock, deleteInstructionVisitor: deleteInstructionVisitor)
                            case .expression:
                                self.codeBlock.accept(visitor: deleteExpressionVisitor)
                                self.processDraggedExpression(draggedID: draggedID, targetInstructionID: targetInstructionID, codeBlock: codeBlock, deleteExpressionVisitor: deleteExpressionVisitor)
                            case .newExpression:
                                //on an new expression we don't need to perform the delete visit -> performance
                                self.processDraggedExpression(draggedID: draggedID, targetInstructionID: targetInstructionID, codeBlock: codeBlock, deleteExpressionVisitor: deleteExpressionVisitor)
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    func dragItem(for instruction: any Instruction, suggestedName: String) -> NSItemProvider {
        let idString = instruction.id.uuidString
        let provider = NSItemProvider(object: idString as NSString)
    
        provider.suggestedName = suggestedName
        
        return provider
    }
    
    private func processDraggedExpression(
        draggedID: UUID,
        targetInstructionID: UUID?,
        codeBlock: CodeBlock?,
        deleteExpressionVisitor: DeleteExpressionVisitor
    ) {
        if !deleteExpressionVisitor.getWasDeleted() {
            let newInstructionVisitor = NewInstructionVisitor()
            
            guard let newInstruction = self.findInstructionByID(draggedID: draggedID) else {
                return
            }
            newInstruction.accept(visitor: newInstructionVisitor)
            
            if let newExpression = newInstructionVisitor.get() as? Expression {
                deleteExpressionVisitor.setDeletedExpression(expression: newExpression)
            }
        }
        
        guard let existingTargetInstructionID = targetInstructionID else {
            return
        }
        
        let addExpressionVisitor = AddExpressionVisitor(targetId: existingTargetInstructionID, expression: deleteExpressionVisitor.getDeletedExpression())
        self.codeBlock.accept(visitor: addExpressionVisitor)
    }
    
    private func processDraggedInstruction(
        draggedID: UUID,
        targetInstructionID: UUID?,
        codeBlock: CodeBlock?,
        deleteInstructionVisitor: DeleteInstructionVisitor
    ) {
        if !deleteInstructionVisitor.getWasDeleted() {
            let newInstructionVisitor = NewInstructionVisitor()
            
            guard let newInstruction = self.findInstructionByID(draggedID: draggedID) else {
                return
            }
            newInstruction.accept(visitor: newInstructionVisitor)
            deleteInstructionVisitor.setDeletedInstruction(instruction: newInstructionVisitor.get())
        }
        
        //If we want to add it to the end of the List
        guard let existingTargetInstructionID = targetInstructionID else {
            guard let existingCodeBlock = codeBlock else {
                self.codeBlock.addInstruction(instruction: deleteInstructionVisitor.getDeletedInstruction())
                return
            }
            existingCodeBlock.addInstruction(instruction: deleteInstructionVisitor.getDeletedInstruction())
            return
        }
        
        let addInstructionVisitor = AddInstructionVisitor(targetId: existingTargetInstructionID, instruction: deleteInstructionVisitor.getDeletedInstruction())
        self.codeBlock.accept(visitor: addInstructionVisitor)
    }
    
    private func findInstructionByID(draggedID: UUID) -> (any Instruction)? {
        // Check if the draggedID exists in allStatements or allControllFlow
        if let statement = allStatements.first(where: { $0.id == draggedID }) {
            return statement
        }
        if let controlFlow = allControllFlow.first(where: { $0.id == draggedID }) {
            return controlFlow
        }
        
        if let expression = allExpressions.first(where: { $0.id == draggedID }) {
            return expression
        }
        
        // Return nil if the draggedID is not found in either collection
        return nil
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
