//
//  MockModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

@Observable
class MockModel: Model { //Used for Previews and not persisting
    override init() {
        super.init()
        
        // Disable persistence
        projects = [
            Project(codeBlock: CodeBlock([Step(), Lift()]), lastEdited: Date()),
            Project(codeBlock: CodeBlock(), worldWidth: 10, worldLength: 10, lastEdited: Date()),
            Project(codeBlock: CodeBlock(), worldWidth: 20, worldLength: 20, lastEdited: Date())
        ]
        
        exerciseTemplates = [
            Exercise(exampleSolution: CodeBlock([Step()]), worldWidth: 10, worldLength: 10, exerciseDescription: "Make two steps", lastEdited: Date()),
            Exercise(lastEdited: Date())
        ]
    }
    
    override func saveProject(project: Project) {
        // Do nothing to prevent saving
    }
    
    override func loadProjects() {
        // Do nothing to prevent loading
    }
    
    override func deleteProjectFile(project: Project) {
        // Do nothing to prevent loading
    }
}
