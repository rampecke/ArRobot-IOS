//
//  ExerciseCodeEditorViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import Foundation
import RealityFoundation

@Observable
class ExerciseEditorViewModel: CodeEditorViewModel {
    private var exercise: Exercise
    var draftExercise: Exercise
    var queue = DispatchQueue(label: "com.ramonaeckert.executeTask")
    
    var cameraAnchor = AnchorEntity()
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.draftExercise = Exercise(worldWidth: exercise.worldWidth, worldLength: exercise.worldLength, exerciseName: exercise.exerciseName, exerciseDescription: exercise.exerciseDescription, exerciseDifficulty: exercise.exerciseDifficulty) //Copy the variables so we don't change them in the actuall exercise and do it onSave
        
        //TODO: GIVE THE PROJECT A COPY OF THE EXERCISESOLUTION CODEBLOCK instead of the real one (would change in the model without saving)
        super.init(project: Project( codeBlock: exercise.exampleSolution, worldWidth: exercise.worldWidth, worldLength: exercise.worldLength))
        
        //Overwrite the visitor to not perform any ar-actions
        self.executionVisitor = NoARExecutionVisitor(world: self.world)
    }
    
    func getExerciseToSave() -> Exercise {
        moveDraftValuesToExercise()
        return exercise
    }
    
    private func moveDraftValuesToExercise() {
        exercise.exerciseName = draftExercise.exerciseName
        exercise.worldLength = draftExercise.worldLength
        exercise.worldWidth = draftExercise.worldWidth
        exercise.exerciseDescription = draftExercise.exerciseDescription
        exercise.exerciseDifficulty = draftExercise.exerciseDifficulty
        
        //Copy codeblock from the Project editor
        exercise.exampleSolution = project.codeBlock
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
            
            self.next()
            
            callCounter = callCounter + 1
            
            if callCounter == maxCalls {
                executionVisitor.endExecution = true
                executionVisitor.executionMessage = "Reached executionlimit of \(maxCalls)"
                return
            }
        }
        
        //If execution ended for whatever reason draw the world
        if executionVisitor.endExecution || executionVisitor.finishedExecution || callCounter == maxCalls {
            DispatchQueue.main.asyncAndWait {
                self.world.drawWorldState()
            }
        }
    }
    
    func setNewWithInWorld() {
        self.world.setWidth(newWidth: self.draftExercise.worldWidth, viewModel: self)
        self.cameraDistance = world.tileWidth * Float(world.getLength()) + 0.1
        cameraAnchor.position = [cameraAnchor.position.x, cameraAnchor.position.y, cameraDistance]
        cameraAnchor.look(at: [0, 0, 0], from: cameraAnchor.position, relativeTo: nil)
    }
    
    func setNewLengthInWorld() {
        self.world.setLength(newLength: self.draftExercise.worldLength, viewModel: self)
        self.cameraDistance = world.tileWidth * Float(world.getLength()) + 0.1
        cameraAnchor.position = [cameraAnchor.position.x, cameraAnchor.position.y, cameraDistance]
        cameraAnchor.look(at: [0, 0, 0], from: cameraAnchor.position, relativeTo: nil)
    }
    
    override func reset() {
        executionStartedRunning = false
        
        let resetVisitor = ResetCodeBlockVisitor()
        project.codeBlock.accept(visitor: resetVisitor)
        
        world.resetWorld()
        //Use the correct visitor
        self.executionVisitor = NoARExecutionVisitor(world: world)
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
