//
//  Room.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import Foundation

struct Room: Identifiable, Codable {
    var id: String { code } // Use room code as a unique identifier
    let code: String
    let owner: Bool
    var participants: [Participant]
}
