//
//  Exercise.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable

@Observable
class Exercise: Identifiable, Codable, Transferable { //Does not inheritate from Project -> We want to differentiate the transferable type
    var id: UUID = UUID()
    var worldWidth: Int
    var worldLength: Int
    var exerciseName: String
    var exampleSolution: CodeBlock
    var exerciseDescription: String
    var exerciseDifficulty: ExerciseDifficulty
    
    init(exampleSolution: CodeBlock = CodeBlock(), worldWidth: Int = 6, worldLength: Int = 6, exerciseName: String = "Untitled Exercise", exerciseDescription: String = "", exerciseDifficulty: ExerciseDifficulty = .easy) {
        self.exampleSolution = exampleSolution
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        self.exerciseName = exerciseName
        self.exerciseDescription = exerciseDescription
        self.exerciseDifficulty = exerciseDifficulty
    }
    
    func changeExerciseName(_ newName: String) {
        self.exerciseName = newName
    }
    
    //For Transferable -> Needed for Airdrop
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .exercise)
            .suggestedFileName { exercise in
                return "ArRoboExercise-\(exercise.exerciseName.replacingOccurrences(of: " ", with: "_"))" // Replace spaces to avoid issues
            }
    }
}

extension UTType {
    static var exercise = UTType(exportedAs: "com.ramonaeckert.RobotKarolArKit.roboArExercise")
}

enum ExerciseDifficulty: Codable {
    case easy, medium, hard
}
