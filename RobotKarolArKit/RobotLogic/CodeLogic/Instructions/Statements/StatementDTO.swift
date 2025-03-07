//
//  StatementDTO.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

//I had to create this DTO because Apple has issues handling inheritance -> have to cast it myself
class StatementDTO: Codable {
    var id: UUID
    var type: String
    var codeBlock: [StatementDTO]?
    var executionIndex: Int?
    var expression: ExpressionDTO?
    
    init(id: UUID, type: String, codeBlock: [StatementDTO]? = nil, executionIndex: Int? = nil, expression: ExpressionDTO? = nil) {
        self.id = id
        self.type = type
        self.codeBlock = codeBlock
        self.executionIndex = executionIndex
        self.expression = expression
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
            let newExpression = (expression ?? ExpressionDTO(id: UUID(), type: "")).returnExpression()
            return If(newCodeBlock, expression: newExpression)
        case "whileStatement":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            let newExpression = (expression ?? ExpressionDTO(id: UUID(), type: "")).returnExpression()
            return While(newCodeBlock, expression: newExpression)
        default:
            return Statement()
        }
    }
}
