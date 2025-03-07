//
//  StatementDTO.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

class StatementDTO: Codable {
    var id: UUID
    var type: String
    var codeBlock: [StatementDTO]?
    var executionIndex: Int?
    
    init(id: UUID, type: String, codeBlock: [StatementDTO]? = nil, executionIndex: Int? = nil) {
        self.id = id
        self.type = type
        self.codeBlock = codeBlock
        self.executionIndex = executionIndex
    }
    
    func returnStatement() -> Statement {
        switch type {
        case "step": return Step()
        case "lift": return Lift()
        case "rightTurn": return RightTurn()
        case "leftTurn": return LeftTurn()
        case "placeGrass": return PlaceGrass()
        case "placeStone": return PlaceStone()
        case "placeWater": return PlaceWater()
        case "codeBlock":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            return CodeBlock(newCodeBlock)
        case "ifStatement":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            return If(newCodeBlock)
        case "whileStatement":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            return While(newCodeBlock)
        default:
            return Statement()
        }
    }
}
