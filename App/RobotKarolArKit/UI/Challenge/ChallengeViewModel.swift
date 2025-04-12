//
//  ChallengeViewModel.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import Foundation
import SwiftStomp

@Observable
class ChallengeViewModel {
    var room: Room? = nil
    var isLoading: Bool = false
    var errorMessage: String?
    
    //private let baseUrl = "robocraft.aet.cit.tum.de"
    private let baseUrl = "192.168.178.132:8080"

    private var urlPrefix: String {
        return "http://\(baseUrl)/rooms"
    }
    
    private let userId: String = UserIdentifier.shared.id
    
    var roomCode: String = ""
    var userName: String = ""
    
    private var stompClient: SwiftStomp?
    
    var currentExercise: Exercise?
    var readyForNextExercise: Bool = true
    var exerciseStarted: Bool = true
    var exerciseDidLoad: Bool = true
    
    var plannedExerciseList: [Exercise] = []
    var pastExerciseList: [Exercise] = []
    
    var myFetchedRooms: [Room] = []
    
    init() {
       self.fetchOwnedRooms()
    }
        
    // Function to connect to WebSocket via STOMP
    func connectToWebSocket() {
        let webSocketURL = "ws://\(self.baseUrl)/ws"
        let url = URL(string: webSocketURL)!
        stompClient = SwiftStomp(host: url)
        stompClient?.delegate = self
        stompClient?.autoReconnect = true
        
        print("🟢 Connecting to WebSocket at \(webSocketURL)...")
        stompClient?.connect()
    }
    
    func disconnectWebSocket() {
        print("🔴 Disconnecting WebSocket...")
        room = nil
        currentExercise = nil
        stompClient?.disconnect()
    }
    
    // Generic function to handle API requests
    private func performRequest(endpoint: String, method: String, body: [String: Any]? = nil) {
        guard let url = URL(string: "\(urlPrefix)/\(endpoint)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        if stompClient != nil {
            disconnectWebSocket()
        }

        isLoading = true
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body, let jsonData = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = jsonData
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let room = try decoder.decode(Room.self, from: data)
                    self.room = room  // Assign the decoded room to your property
                } catch {
                    self.errorMessage = "Error decoding room: \(error.localizedDescription)"
                    print("Error decoding room: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // Create Room function using performRequest
    func createRoom() {
        performRequest(endpoint: "create", method: "POST", body: ["owner": userId])
    }

    // Join Room function using performRequest
    func joinRoom(roomCode: String? = nil) {
        performRequest(endpoint: "\(roomCode ?? self.roomCode)/join", method: "POST", body: ["userName": userName, "userId": userId])
    }
    
    func leaveRoom() {
        guard let code = self.room?.code else {
            return
        }
        
        guard let url = URL(string: "\(self.urlPrefix)/\(code)/leave") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["userId": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
    
    func fetchOwnedRooms() {
        guard let url = URL(string: "\(self.urlPrefix)/owned-rooms/\(self.userId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.errorMessage = "Error fetching rooms: \(error.localizedDescription)"
                self.myFetchedRooms = []
                return
            }

            guard let data = data else {
                self.errorMessage = "No data received"
                self.myFetchedRooms = []
                return
            }

            do {
                // Parse the response JSON into an array of Room objects
                let decoder = JSONDecoder()
                let roomsResponse = try decoder.decode([Room].self, from: data)
                self.myFetchedRooms = roomsResponse  // Assign the result to the array
            } catch {
                self.errorMessage = "Error decoding rooms: \(error.localizedDescription)"
            }
        }

        task.resume()
    }
    
    func deleteRoom(roomCode: String, userId: String) {
        guard let url = URL(string: "\(self.urlPrefix)/delete/\(roomCode)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Body with userId
        let body: [String: String] = ["userId": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.errorMessage = "Error deleting problem: \(error)"
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = jsonResponse["message"] as? Bool {
                    // If the deletion is successful, update the local array by removing the room
                    if success {
                        DispatchQueue.main.async {
                            // Remove the room from the local rooms list
                            self.myFetchedRooms.removeAll { $0.code == roomCode }
                        }
                    }
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func sendExercise(exercise: Exercise) {
        guard let code = self.room?.code else {
            return
        }
        
        guard let url = URL(string: "\(self.urlPrefix)/\(code)/exercise") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert Exercise to JSON String
        guard let exerciseData = try? JSONEncoder().encode(exercise) else {
            print("Failed to encode exercise")
            return
        }
        
        guard let exerciseString = String(data: exerciseData, encoding: .utf8) else {
            print("Failed to convert exercise data to String")
            return
        }
        
        let body: [String: String] = [
            "userId": userId,
            "exercise": exerciseString,
            "exerciseId": exercise.id.uuidString
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}

// MARK: - STOMP Delegate Methods
extension ChallengeViewModel: SwiftStompDelegate {
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("WebSocket disconnected!")
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        // Ensure message is a valid JSON string
        guard let messageString = message as? String,
              let jsonData = messageString.data(using: .utf8) else {
            print("Invalid message format")
            return
        }

        if destination.contains("/topic/room/") {
            // Handle room updates
            DispatchQueue.main.async {
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let participantsData = json["participants"] as? [[String: Any]] {
                        let participants = participantsData.compactMap { dict -> Participant? in
                            guard let id = dict["id"] as? String,
                                  let name = dict["name"] as? String,
                                  let score = dict["score"] as? Int,
                                  let isActive = dict["isActive"] as? Bool else { return nil }
                            return Participant(id: id, name: name, score: score, isActive: isActive)
                        }
                        self.room?.participants = participants
                    } else {
                        print("Unexpected JSON format")
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
        } else if destination.contains("/topic/exercise/") {
            self.exerciseStarted = false
            self.readyForNextExercise = false
            self.exerciseDidLoad = false
            
            DispatchQueue.main.async {
                do {
                    let exercise = try JSONDecoder().decode(Exercise.self, from: jsonData)
                    if self.currentExercise == exercise {
                        self.exerciseDidLoad = true
                    } else {
                        self.currentExercise = exercise
                    }
                } catch {
                    print("Failed to decode exercise")
                }
            }
        }
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("onReceipt was called")
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("WebSocket error: \(briefDescription) | Details: \(String(describing: fullDescription))")
    }
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("WebSocket connected!")
        
        guard let code = self.room?.code else {return}
        print("Subscribing to /topic/room/\(code)")
        stompClient?.subscribe(to: "/topic/room/\(code)")
        print("Subscribing to /topic/exercise/\(code)")
        stompClient?.subscribe(to: "/topic/exercise/\(code)")
        
    }
}

class UserIdentifier {
    static let shared = UserIdentifier()
    let id: String

    private init() {
        let key = "UserIdentifier"
        if let savedId = UserDefaults.standard.string(forKey: key) {
            id = savedId
        } else {
            let newId = UUID().uuidString
            UserDefaults.standard.set(newId, forKey: key)
            id = newId
        }
    }
}

struct ExerciseDTO: Identifiable, Codable {
    var id: String
    var status: String
}

