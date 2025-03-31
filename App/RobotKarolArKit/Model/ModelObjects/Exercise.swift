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
class Exercise: Identifiable, Codable, Transferable, Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    //Does not inheritate from Project -> We want to differentiate the transferable type
    var id: UUID = UUID()
    var worldWidth: Int
    var worldLength: Int
    var exerciseName: String
    var exampleSolution: CodeBlock
    var exerciseDescription: String
    var exerciseDifficulty: ExerciseDifficulty
    var solutionTiles: [[Tile]]
    var lastEdited: Date?
    
    init(exampleSolution: CodeBlock = CodeBlock(), worldWidth: Int = 6, worldLength: Int = 6, exerciseName: String = "Untitled Exercise", exerciseDescription: String = "", exerciseDifficulty: ExerciseDifficulty = .easy, solutionTiles: [[Tile]] = [[]], lastEdited: Date? = nil) {
        self.exampleSolution = exampleSolution
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        self.exerciseName = exerciseName
        self.exerciseDescription = exerciseDescription
        self.exerciseDifficulty = exerciseDifficulty
        self.solutionTiles = solutionTiles
        self.lastEdited = lastEdited
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
    
    func getCopyExercise() -> Exercise {
        let codeBlockCopyVisitor = CopyCodeBlockVisitor()
        self.exampleSolution.accept(visitor: codeBlockCopyVisitor)
        let copyExercise = Exercise(exampleSolution: codeBlockCopyVisitor.returnCodeBlock(), worldWidth: self.worldWidth, worldLength: self.worldLength, exerciseName: self.exerciseName, exerciseDescription: self.exerciseDescription, exerciseDifficulty: self.exerciseDifficulty, solutionTiles: self.solutionTiles)
        
        return copyExercise
    }
}

extension UTType {
    static var exercise = UTType(exportedAs: "de.tum.cit.aet.robocraft.roboArExercise")
}

enum ExerciseDifficulty: Codable, Comparable {
    case easy, medium, hard
    
    var colorName: String {
        switch self {
        case .easy: return "folder_color_easy"
        case .medium: return "folder_color_medium"
        case .hard: return "folder_color_hard"
        }
    }
    
    static func < (lhs: ExerciseDifficulty, rhs: ExerciseDifficulty) -> Bool {
        switch (lhs, rhs) {
        case (.easy, .medium), (.easy, .hard), (.medium, .hard):
            return true
        default:
            return false
        }
    }
}
