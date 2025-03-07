//
//  Model.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

@Observable
class Model {
    var projects: [Project] = [] {
        didSet {
            saveProjects() // Auto-save on changes (only changes on list it self)
        }
    }

    init() {
        loadProjects()
    }
    
    func addNewProject() {
        projects.append(Project())
    }

    
    // MARK: - Persistence
    private var fileURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return path.appendingPathComponent("projects.json")
    }

    func saveProjects() {
        do {
            let data = try JSONEncoder().encode(projects)
            try data.write(to: fileURL)
        } catch {
            print("Error saving projects: \(error.localizedDescription)")
        }
    }

    func loadProjects() {
        do {
            let data = try Data(contentsOf: fileURL)

            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw file content: \n\(rawString)")
            } else {
                print("Unable to convert data to string.")
            }
            projects = try JSONDecoder().decode([Project].self, from: data)
        } catch {
            print("Error loading projects: \(error.localizedDescription)")
            projects = [] // Initialize empty if decoding fails
        }
    }
}
