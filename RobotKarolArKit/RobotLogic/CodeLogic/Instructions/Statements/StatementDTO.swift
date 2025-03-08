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
        case "step": return Step(id: id)
        case "lift": return Lift(id: id)
        case "rightTurn": return RightTurn(id: id)
        case "leftTurn": return LeftTurn(id: id)
        case "placeGrass": return PlaceGrass(id: id)
        case "placeStone": return PlaceStone(id: id)
        case "placeWater": return PlaceWater(id: id)
        case "codeBlock":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            return CodeBlock(newCodeBlock)
        case "ifStatement":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            let newExpression = (expression ?? ExpressionDTO(id: UUID(), type: "")).returnExpression()
            return If(newCodeBlock, expression: newExpression, id: id)
        case "whileStatement":
            let newCodeBlock = (codeBlock ?? []).map{$0.returnStatement()}
            let newExpression = (expression ?? ExpressionDTO(id: UUID(), type: "")).returnExpression()
            return While(newCodeBlock, expression: newExpression, id: id)
        default:
            return Statement(id: id)
        }
    }
}
