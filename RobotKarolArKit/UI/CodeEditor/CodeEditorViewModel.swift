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
    var allStatements: [Statement] = [Step(), Lift(), RightTurn(), LeftTurn(), PlaceGrass(), PlaceStone(), PlaceWater()]
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
    
    private func addStatement(statement: Statement) {
        codeBlock.addStatement(statement: statement)
    }
    
    func createNewStatement(statement: Statement) {
        let newInstructionVisitor = NewInstructionVisitor()
        statement.accept(visitor: newInstructionVisitor)
        
        guard let newStatement = newInstructionVisitor.get() as? Statement else {
            return
        }
        addStatement(statement: newStatement)
    }
    
    func addStatementToPosition(statement: Statement, position: Int) {
        let newInstructionVisitor = NewInstructionVisitor()
        statement.accept(visitor: newInstructionVisitor)
        
        guard let newStatement = newInstructionVisitor.get() as? Statement else {
            return
        }
        codeBlock.addStatementAtPosition(statement: newStatement, position: position)
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
    func handleStatementDrop (statement: Statement, targetStatement: Statement, addToEndOfTarget: Bool? = nil) {
        if statement.id == targetStatement.id { return }
        
        let deleteStatementVisitor = DeleteStatementVisitor(deleteId: statement.id)
        
        let allInstructions = allStatements + allControllFlow
        if let statementType = allInstructions.first(where: { $0.id == statement.id }) {
            let newInstructionVisitor = NewInstructionVisitor()
            statementType.accept(visitor: newInstructionVisitor)
            
            guard let newStatement = newInstructionVisitor.get() as? Statement else { return }
            deleteStatementVisitor.setDeletedStatement(statement: newStatement)
        } else {
            self.codeBlock.accept(visitor: deleteStatementVisitor)
        }
        
        if addToEndOfTarget ?? false {
            guard let targetCodeBlock = targetStatement as? CodeBlock else { return }
            
            targetCodeBlock.addStatement(statement: deleteStatementVisitor.getDeletedStatement())
        } else {
            
            let addInstructionVisitor = AddStatementVisitor(targetId: targetStatement.id, statement: deleteStatementVisitor.getDeletedStatement())
            //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
            self.codeBlock.accept(visitor: addInstructionVisitor)
        }
    }
    
    func handleExpressionDrop (expression: Expression, targetExpression: Expression) {
        if expression.id == targetExpression.id { return }
        
        let deleteExpressionVisitor = DeleteExpressionVisitor(deleteId: expression.id)
        
        if let expressionType = allExpressions.first(where: { $0.id == expression.id }) {
            let newInstructionVisitor = NewInstructionVisitor()
            expressionType.accept(visitor: newInstructionVisitor)
            
            guard let newExpression = newInstructionVisitor.get() as? Expression else { return }
            deleteExpressionVisitor.setDeletedExpression(expression: newExpression)
        } else {
           //If it is not a new expression delete the old one
            self.codeBlock.accept(visitor: deleteExpressionVisitor)
        }
        
        let addExpressionVisitor = AddExpressionVisitor(targetId: targetExpression.id, expression: deleteExpressionVisitor.getDeletedExpression())
        //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
        self.codeBlock.accept(visitor: addExpressionVisitor)
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
