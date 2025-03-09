//
//  CodeEditorViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

@Observable
class CodeEditorViewModel {
    var allStatements: [Statement] = [Step(), Lift(), RightTurn(), LeftTurn(), PlaceGrass(), PlaceStone(), PlaceWater()]
    var allControllFlow: [CodeBlock] = [If(), While()]
    var allExpressions: [Expression] = [IsEast(), IsWest(), IsNorth(), IsSouth(), IsBlock(), IsBorder(), And(), Or(), Not()]
    var bottomBarTargeted = false
    
    var world = World(width: 6, length: 6)
    var executionVisitor: ExecutionVisitor
    var executionSpeed: PlaySpeed = .normal
    var arType: ARType = ARType.AR
    
    var executionRunning = false
    
    var dragInstruction = false
    var dragExpression = false
    var dragNewInstruction = false
    
    var project: Project
    
    init(project: Project = Project()) {
        let newWorld = World(width: project.worldWidth, length: project.worldLength)
        self.world = newWorld
        self.executionVisitor = ExecutionVisitor(world: newWorld)
        self.project = project
    }
    
    //Whenever we start a drag we need to call one of these to make sure our dragging states are set correctly
    func dragNewStatement() {
        dragInstruction = false
        dragExpression = false
        dragNewInstruction = true
    }
    
    func dragExistingInstruction() {
        dragInstruction = true
        dragExpression = false
        dragNewInstruction = false
    }
    
    func dragExistingExpression() {
        dragInstruction = false
        dragExpression = true
        dragNewInstruction = false
    }
    
    func dragNewExpression() {
        dragInstruction = false
        dragExpression = false
        dragNewInstruction = false
    }
    
    private func addStatement(statement: Statement) {
        //Reset Execution when adding new code
        if executionRunning {
            reset()
        }
        
        project.codeBlock.addStatement(statement: statement)
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
        //Reset Execution when adding new code
        if executionRunning {
            reset()
        }
        
        let newInstructionVisitor = NewInstructionVisitor()
        statement.accept(visitor: newInstructionVisitor)
        
        guard let newStatement = newInstructionVisitor.get() as? Statement else {
            return
        }
        project.codeBlock.addStatementAtPosition(statement: newStatement, position: position)
    }
    
    func addNewExpressionAtNextEmptyPosition(expression: Expression) {
        if executionRunning {
            reset()
        }
        
        let newInstructionVisitor = NewInstructionVisitor()
        expression.accept(visitor: newInstructionVisitor)
        
        guard let newExpression = newInstructionVisitor.get() as? Expression else {
            return
        }
        
        let addExpressionToEmptyVisitor = AddExpressionIntoEmptyVisitor(expressionToAdd: newExpression)
        project.codeBlock.accept(visitor: addExpressionToEmptyVisitor)
    }
    
    func next() {
        if !executionRunning {
            executionRunning = true
        }
        
        if executionVisitor.endExecution || executionVisitor.finishedExecution {
            return
        } else {
            project.codeBlock.accept(visitor: executionVisitor)
        }
    }
    
    func executeAll() {
        if !executionRunning {
            executionRunning = true
        }
        
        executeNextStep()
    }

    private func executeNextStep() {
        // Check the stopping conditions -> Make sure we don't call the dispatcher again
        guard !executionVisitor.endExecution && !executionVisitor.finishedExecution else {
            return
        }
        
        if executionRunning { //make sure to only run when execution is still running
            // Execute the next step
            next()
            
            // dispatchTime 2 seconds from now:
            let dispatchTime: DispatchTime = DispatchTime.now() + executionSpeed.timeInterval
            // Schedule the next step after executionTime second
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.executeNextStep()
            }
        }
    }
    func reset() {
        executionRunning = false
        
        let resetVisitor = ResetCodeBlockVisitor()
        project.codeBlock.accept(visitor: resetVisitor)
        
        world.resetWorld()
        self.executionVisitor = ExecutionVisitor(world: world)
    }
    
    func resetCode() {
        project.codeBlock.codeBlock = []
        
        reset()
    }
    
    func deleteInstruction(deleteId: UUID) {
        if executionRunning {
            reset()
        }
        
        let deleteStatementVisitor = DeleteStatementVisitor(deleteId: deleteId)
        project.codeBlock.accept(visitor: deleteStatementVisitor)
    }
    
    func deleteExpression(deleteId: UUID) {
        if executionRunning {
            reset()
        }
        
        let deleteExpressionVisitor = DeleteExpressionVisitor(deleteId: deleteId)
        project.codeBlock.accept(visitor: deleteExpressionVisitor)
    }
    
    //New Drag and Drop functions
    func handleStatementDrop (statement: Statement, targetStatement: Statement, addToEndOfTarget: Bool? = nil) {
        //Stop&Reset execution when adding new statement
        if executionRunning {
            reset()
        }
        
        if statement.id == targetStatement.id { return }
        
        let deleteStatementVisitor = DeleteStatementVisitor(deleteId: statement.id)
        
        let allInstructions = allStatements + allControllFlow
        if let statementType = allInstructions.first(where: { $0.id == statement.id }) {
            let newInstructionVisitor = NewInstructionVisitor()
            statementType.accept(visitor: newInstructionVisitor)
            
            guard let newStatement = newInstructionVisitor.get() as? Statement else { return }
            deleteStatementVisitor.setDeletedStatement(statement: newStatement)
        } else {
            project.codeBlock.accept(visitor: deleteStatementVisitor)
        }
        
        if addToEndOfTarget ?? false {
            guard let targetCodeBlock = targetStatement as? CodeBlock else { return }
            
            targetCodeBlock.addStatement(statement: deleteStatementVisitor.getDeletedStatement())
        } else {
            
            let addInstructionVisitor = AddStatementVisitor(targetId: targetStatement.id, statement: deleteStatementVisitor.getDeletedStatement())
            //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
            project.codeBlock.accept(visitor: addInstructionVisitor)
        }
    }
    
    func handleExpressionDrop (expression: Expression, targetExpression: Expression) {
        //Stop&Reset execution when adding new expression
        if executionRunning {
            reset()
        }
        
        if expression.id == targetExpression.id { return }
        
        let deleteExpressionVisitor = DeleteExpressionVisitor(deleteId: expression.id)
        
        if let expressionType = allExpressions.first(where: { $0.id == expression.id }) {
            let newInstructionVisitor = NewInstructionVisitor()
            expressionType.accept(visitor: newInstructionVisitor)
            
            guard let newExpression = newInstructionVisitor.get() as? Expression else { return }
            deleteExpressionVisitor.setDeletedExpression(expression: newExpression)
        } else {
           //If it is not a new expression delete the old one
            project.codeBlock.accept(visitor: deleteExpressionVisitor)
        }
        
        let addExpressionVisitor = AddExpressionVisitor(targetId: targetExpression.id, expression: deleteExpressionVisitor.getDeletedExpression())
        //TODO: Maybe add the codeblock the expression was dropped to the call -> Performance
        project.codeBlock.accept(visitor: addExpressionVisitor)
    }
}

enum ARType: CaseIterable {
    case AR
    case NonAR
    
    var displayName: String {
        switch self {
        case .AR: return "Real Life"
        case .NonAR: return "Simulator"
        }
    }
}

enum DragItemType: String {
    case instruction
    case newInstruction
    case expression
    case newExpression
}

enum PlaySpeed: CaseIterable {
    case superSlow, slow, normal, fast, superFast
    
    var timeInterval: DispatchTimeInterval {
        let seconds = self.value
        return .milliseconds(Int(seconds * 1000))  // Convert Float seconds to milliseconds
    }

    var value: Float {
        switch self {
            case .superSlow: return 2.0
            case .slow: return 1.0
            case .normal: return 0.5
            case .fast: return 0.25
            case .superFast: return 0.125
        }
    }

    var displayName: String {
        switch self {
            case .superSlow: return "Super Slow"
            case .slow: return "Slow"
            case .normal: return "Normal"
            case .fast: return "Fast"
            case .superFast: return "Super Fast"
        }
    }
    
    var iconName: String {
        switch self {
            case .superSlow: return "custom.slowest.fill"
            case .slow: return "custom.slower.fill"
            case .normal: return "play.fill"
            case .fast: return "forward.fill"
            case .superFast: return "custom.fastforward.fill"
        }
    }
}
