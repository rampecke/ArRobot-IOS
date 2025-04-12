//
//  Room.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import Foundation

struct Room: Identifiable, Codable, Equatable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.code == rhs.code && lhs.isOwner == rhs.isOwner && lhs.participants == rhs.participants
    }
    
    var id: String { code } // Use room code as a unique identifier
    let code: String
    let isOwner: Bool
    var participants: [Participant]
}
