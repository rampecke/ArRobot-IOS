//
//  Project.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

@Observable
class Project: Identifiable, Codable {
    var id: UUID = UUID()
    var worldWidth: Int
    var worldLength: Int
    var name: String
    var codeBlock: CodeBlock
    
    init(codeBlock: CodeBlock = CodeBlock(), worldWidth: Int = 6, worldLength: Int = 6, name: String = "Untitled Project") {
        self.codeBlock = codeBlock
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        self.name = name
    }
    
    func changeProjectName(_ newName: String) {
        self.name = newName
    }
}
