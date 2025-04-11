//
//  Project.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

@Observable
class Project: Identifiable, Codable, Transferable {
    var id: UUID = UUID()
    var worldWidth: Int
    var worldLength: Int
    var name: String
    var codeBlock: CodeBlock
    var lastEdited: Date?
    
    var exercise: Exercise?
    
    init(codeBlock: CodeBlock = CodeBlock(), worldWidth: Int = 6, worldLength: Int = 6, name: String = "Untitled Project", exercise: Exercise? = nil, lastEdited: Date? = nil) {
        self.codeBlock = codeBlock
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        self.name = name
        self.exercise = exercise
        self.lastEdited = lastEdited
    }
    
    func changeProjectName(_ newName: String) {
        self.name = newName
    }
    
    //For Transferable -> Needed for Airdrop
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .project)
            .suggestedFileName { project in
                return "ArRoboProject-\(project.name.replacingOccurrences(of: " ", with: "_"))" // Replace spaces to avoid issues
            }
    }
}

extension UTType {
    static var project = UTType(exportedAs: "de.tum.cit.aet.robocraft.roboArProject")
}
