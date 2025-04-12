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
    var isReady: Bool
    var completedExercises: [String: Date]
    
    
    init(id: String, name: String, score: Int, isActive: Bool, isReady: Bool, completedExercises: [String: Date] = [:]) {
        self.id = id
        self.name = name
        self.score = score
        self.isActive = isActive
        self.isReady = isReady
        self.completedExercises = completedExercises
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case score
        case isActive
        case isReady
        case completedExercises
    }
    
    // Shared formatter for decoding/encoding completedExercises
    private static let preciseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        score = try container.decode(Int.self, forKey: .score)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        isReady = try container.decode(Bool.self, forKey: .isReady)

        let completedStrings = try container.decodeIfPresent([String: String].self, forKey: .completedExercises) ?? [:]
        completedExercises = completedStrings.compactMapValues {
            Participant.preciseDateFormatter.date(from: $0)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(score, forKey: .score)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(isReady, forKey: .isReady)

        let completedStrings = completedExercises.mapValues {
            Participant.preciseDateFormatter.string(from: $0)
        }
        try container.encode(completedStrings, forKey: .completedExercises)
    }
}
