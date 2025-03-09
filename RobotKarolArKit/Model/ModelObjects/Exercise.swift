//
//  Exercise.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import Foundation

@Observable
class Exercise: Identifiable, Codable{
    var id: UUID = UUID()
    var worldWidth: Int
    var worldLength: Int
    var exerciseName: String
    var exampleSolution: CodeBlock
    var exerciseDescription: String
    
    init(codeBlock: CodeBlock = CodeBlock(), worldWidth: Int = 6, worldLength: Int = 6, exerciseName: String = "Untitled Exercise", exerciseDescription: String = "") {
        self.exampleSolution = codeBlock
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        self.exerciseName = exerciseName
        self.exerciseDescription = exerciseDescription
    }
    
    func changeProjectName(_ newName: String) {
        self.exerciseName = newName
    }
}
