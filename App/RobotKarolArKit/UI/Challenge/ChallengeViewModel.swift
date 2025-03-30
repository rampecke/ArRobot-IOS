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
    
    private let urlPrefix = "http://192.168.178.132:8080/rooms"
    
    private let userId: String = UserIdentifier.shared.id
    
    var roomCode: String = ""
    var userName: String = ""
    
    private var stompClient: SwiftStomp?
        
    // Function to connect to WebSocket via STOMP
    func connectToWebSocket() {
        let webSocketURL = "ws://192.168.178.132:8080/ws"
        let url = URL(string: webSocketURL)!
        stompClient = SwiftStomp(host: url)
        stompClient?.delegate = self
        stompClient?.autoReconnect = true
        
        print("🟢 Connecting to WebSocket at \(webSocketURL)...")
        stompClient?.connect()
    }
    
    func disconnectWebSocket() {
        print("🔴 Disconnecting WebSocket...")
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let code = json["code"] as? String,
                       let isOwner = json["isOwner"] as? Bool,
                       let participantsData = json["participants"] as? [[String: Any]] {
                        
                        let participants = participantsData.compactMap { dict -> Participant? in
                            guard let name = dict["name"] as? String,
                                  let score = dict["score"] as? Int,
                                  let id = dict["id"] as? String else { return nil }
                            return Participant(id: id, name: name, score: score)
                        }

                        self.room = Room(code: code, owner: isOwner, participants: participants)
                        
                        self.connectToWebSocket()
                    } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                              let message = json["message"] as? String {
                        self.errorMessage = message
                    } else {
                        self.errorMessage = "Invalid response format"
                    }
                } catch {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }

    // Create Room function using performRequest
    func createRoom() {
        performRequest(endpoint: "create", method: "POST", body: ["owner": userId])
    }

    // Join Room function using performRequest
    func joinRoom() {
        performRequest(endpoint: "\(roomCode)/join", method: "POST", body: ["userName": userName, "userId": userId])
    }
}

// MARK: - STOMP Delegate Methods
extension ChallengeViewModel: SwiftStompDelegate {
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("WebSocket disconnected!")
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        print("Received message: \(String(describing: message))")
        
        // Ensure message is a valid JSON string
        guard let messageString = message as? String,
              let jsonData = messageString.data(using: .utf8) else {
            print("❌ Invalid message format")
            return
        }

        do {
            // Parse JSON into a dictionary
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let participantsData = json["participants"] as? [[String: Any]] {
                
                let participants = participantsData.compactMap { dict -> Participant? in
                    guard let id = dict["id"] as? String,
                          let name = dict["name"] as? String,
                          let score = dict["score"] as? Int else { return nil }
                    return Participant(id: id, name: name, score: score)
                }
                
                DispatchQueue.main.async {
                    self.room?.participants = participants
                    print("✅ Updated participant list: \(participants)")
                }
            } else {
                print("⚠️ Unexpected JSON format")
            }
        } catch {
            print("❌ Failed to parse JSON: \(error)")
        }
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("onReceipt")
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("WebSocket error: \(briefDescription) | Details: \(String(describing: fullDescription))")
    }
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("WebSocket connected!")
        
        guard let code = self.room?.code else {return}
        print("Subscribing to /topic/room/\(code)")
        let destination = "/topic/room/\(code)"
        stompClient?.subscribe(to: destination)
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

