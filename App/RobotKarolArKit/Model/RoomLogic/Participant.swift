//
//  Participant.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import Foundation

struct Participant: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var score: Int
    var isActive: Bool
}
