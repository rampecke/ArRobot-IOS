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
    var exerciseTemplates: [Exercise] = []

    init() {
        loadProjects()
        loadExercises()
    }
    
    // MARK: - Project Management
    func addNewProject() {
        let newProject = Project()
        projects.append(newProject)
        saveProject(project: newProject) // Save immediately
    }
    
    func deleteProject(project: Project) {
        projects.removeAll(){ $0.id == project.id }
        deleteProjectFile(project: project)
    }
    
    // MARK: - Exercise Management
    func addNewExercise(newExercise: Exercise) {
        print("Was called")
        exerciseTemplates.append(newExercise)
        saveExercise(exercise: newExercise)
    }

    func deleteExercise(exercise: Exercise) {
        exerciseTemplates.removeAll { $0.id == exercise.id }
        deleteExerciseFile(exercise: exercise)
    }
    
    // MARK: - PROJECT PERSISTENCE
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
    
    // MARK: - EXERCISE PERSISTENCE
    private func exerciseDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exercisePath = path.appendingPathComponent("exercises")

        if !FileManager.default.fileExists(atPath: exercisePath.path) {
            do {
                try FileManager.default.createDirectory(at: exercisePath, withIntermediateDirectories: true)
            } catch {
                print("Error creating exercises directory: \(error.localizedDescription)")
            }
        }
        return exercisePath
    }

    private func fileURL(for exercise: Exercise) -> URL {
        return exerciseDirectory().appendingPathComponent("\(exercise.id).json")
    }

    func saveExercise(exercise: Exercise) {
        do {
            let data = try JSONEncoder().encode(exercise)
            try data.write(to: fileURL(for: exercise))
        } catch {
            print("Error saving exercise \(exercise.id): \(error.localizedDescription)")
        }
    }
    
    func deleteExerciseFile(exercise: Exercise) {
        do {
            try FileManager.default.removeItem(at: fileURL(for: exercise))
        } catch {
            print("Error deleting exercise \(exercise.id): \(error.localizedDescription)")
        }
    }

    func loadExercises() {
        let path = exerciseDirectory()
        
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            exerciseTemplates.removeAll()

            for url in fileURLs {
                do {
                    let rawData = try Data(contentsOf: url)
                    let exercise = try JSONDecoder().decode(Exercise.self, from: rawData)
                    exerciseTemplates.append(exercise)
                } catch {
                    print("Error loading exercise from \(url.lastPathComponent): \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error accessing exercise directory: \(error.localizedDescription)")
            exerciseTemplates = []
        }
    }
    
    // MARK: - IMPORT HANDLING
    func importProjectFromFile(url: URL) {
        // Request access to the file (for sandboxed files)
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            // Attempt to decode as Project
            if let project = try? JSONDecoder().decode(Project.self, from: data) {
                // Avoid duplicate projects by checking if `id` exists
                if !projects.contains(where: { $0.id == project.id }) {
                    projects.append(project)
                    saveProject(project: project) // Save it to disk
                    print("Imported project: \(project.name)")
                } else {
                    print("Project already exists: \(project.name)")
                }
            }
            
            // Attempt to decode as Exercise
            if let exercise = try? JSONDecoder().decode(Exercise.self, from: data) {
                if !exerciseTemplates.contains(where: { $0.id == exercise.id }) {
                    exerciseTemplates.append(exercise)
                    saveExercise(exercise: exercise)
                    print("Imported exercise: \(exercise.exerciseName)")
                } else {
                    print("Exercise already exists: \(exercise.exerciseName)")
                }
                return
            }

            print("File format not recognized.")
        } catch {
            print("Error importing project: \(error.localizedDescription)")
        }
    }
}
