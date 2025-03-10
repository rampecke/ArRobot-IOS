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
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init(project: Project(worldWidth: exercise.worldWidth, worldLength: exercise.worldLength))
    }
}
