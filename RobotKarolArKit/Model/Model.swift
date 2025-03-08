//
//  Model.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

@Observable
class Model {
    var projects: [Project] = []

    init() {
        loadProjects()
    }
    
    func addNewProject() {
        let newProject = Project()
        projects.append(newProject)
        saveProject(project: newProject) // Save immediately
    }
    
    func deleteProject(project: Project) {
        projects.removeAll(){ $0.id == project.id }
        deleteProject(project: project)
    }

    
    // MARK: - Persistence
    private func projectsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let projectsPath = path.appendingPathComponent("projects")

        // Ensure the directory exists
        if !FileManager.default.fileExists(atPath: projectsPath.path) {
            do {
                try FileManager.default.createDirectory(at: projectsPath, withIntermediateDirectories: true)
            } catch {
                print("Error creating projects directory: \(error.localizedDescription)")
            }
        }
        return projectsPath
    }

    
    private func fileURL(for project: Project) -> URL {
        return projectsDirectory().appendingPathComponent("\(project.id).json") // Unique file per project
    }

    func saveProject(project: Project) {
        do {
            let data = try JSONEncoder().encode(project)
            try data.write(to: fileURL(for: project))
        } catch {
            print("Error saving project \(project.id): \(error.localizedDescription)")
        }
    }
    
    func deleteProjectFile(project: Project) {
        do {
            try FileManager.default.removeItem(at: fileURL(for: project))
        } catch {
            print("Error deleting project \(project.id): \(error.localizedDescription)")
        }
    }

    func loadProjects() {
        let path = projectsDirectory()
        
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            projects.removeAll() // Clear the current list before loading

            for url in fileURLs {
                do {
                    let rawData = try Data(contentsOf: url)
                    
                    do {
                        let project = try JSONDecoder().decode(Project.self, from: rawData)
                        projects.append(project) // Append only if decoding succeeds
                    } catch let DecodingError.dataCorrupted(context) {
                        print("Data corrupted: \(context)")
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found: \(context.debugDescription)")
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type mismatch for type \(type): \(context.debugDescription)")
                    } catch let DecodingError.valueNotFound(type, context) {
                        print("Value '\(type)' not found: \(context.debugDescription)")
                    } catch {
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                } catch {
                    print("Error loading project from \(url.lastPathComponent): \(error.localizedDescription)")
                }
            }
            
        } catch {
            print("Error accessing project directory: \(error.localizedDescription)")
            projects = []
        }
    }
}
