//
//  ExerciseCodeEditorViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import Foundation

@Observable
class ExerciseEditorViewModel: CodeEditorViewModel {
    var exercise: Exercise
    var queue = DispatchQueue(label: "com.ramonaeckert.executeTask")
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init(project: Project(worldWidth: exercise.worldWidth, worldLength: exercise.worldLength))
    }
    
    func executeAllWithoutDispatcher() {
        queue.async {
            self.executeNextWithoutDispatcher()
        }
    }
    
    private func executeNextWithoutDispatcher(maxCalls: Int = 10000) {
        executionStartedRunning = true
        var callCounter = 0
            
        while executionStartedRunning && !executionVisitor.endExecution && !executionVisitor.finishedExecution {
            next()
            callCounter = callCounter + 1
            
            if callCounter == maxCalls {
                executionVisitor.endExecution = true
                executionVisitor.executionMessage = "Reached executionlimit of \(maxCalls)"
                return
            }
        }
    }
    
    override func addStatementToPosition(statement: Statement, position: Int) {
        super.addStatementToPosition(statement: statement, position: position)
        executeAllWithoutDispatcher()
    }
    
    override func addStatement(statement: Statement) {
        super.addStatement(statement: statement)
        executeAllWithoutDispatcher()
    }
    
    override func addNewExpressionAtNextEmptyPosition(expression: Expression) {
        super.addNewExpressionAtNextEmptyPosition(expression: expression)
        executeAllWithoutDispatcher()
    }
    
    override func deleteInstruction(deleteId: UUID) {
        super.deleteInstruction(deleteId: deleteId)
        executeAllWithoutDispatcher()
    }
    
    override func deleteExpression(deleteId: UUID) {
        super.deleteExpression(deleteId: deleteId)
        executeAllWithoutDispatcher()
    }
    
    override func handleStatementDrop (statement: Statement, targetStatement: Statement, addToEndOfTarget: Bool? = nil) {
        super.handleStatementDrop(statement: statement, targetStatement: targetStatement, addToEndOfTarget: addToEndOfTarget)
        executeAllWithoutDispatcher()
    }
    
    override func handleExpressionDrop (expression: Expression, targetExpression: Expression) {
        super.handleExpressionDrop(expression: expression, targetExpression: targetExpression)
        executeAllWithoutDispatcher()
    }
}
