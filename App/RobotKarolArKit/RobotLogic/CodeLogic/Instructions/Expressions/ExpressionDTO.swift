//
//  ExpressionDTO.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import Foundation

//I had to create this DTO because Apple has issues handling inheritance -> have to cast it myself
class ExpressionDTO: Codable {
    var id: UUID
    var type: String
    var left: ExpressionDTO?
    var right: ExpressionDTO?
    var content: ExpressionDTO?
    
    init(id: UUID, type: String, left: ExpressionDTO? = nil, right: ExpressionDTO? = nil, content: ExpressionDTO? = nil) {
        self.id = id
        self.type = type
        self.content = content
        self.left = left
        self.right = right
    }
    
    func returnExpression() -> Expression {
        switch type {
        case "isEast": return IsEast(id: id)
        case "isWest": return IsWest(id: id)
        case "isNorth": return IsNorth(id: id)
        case "isSouth": return IsSouth(id: id)
        case "isBorder": return IsBorder(id: id)
        case "isBlock": return IsBlock(id: id)
        case "emptyExpression": return EmptyExpression(id: id)
        case "and":
            let newLeft = left?.returnExpression() ?? EmptyExpression()
            let newRight = right?.returnExpression() ?? EmptyExpression()
            return And(left: newLeft, right: newRight, id: id)
        case "or":
            let newLeft = left?.returnExpression() ?? EmptyExpression()
            let newRight = right?.returnExpression() ?? EmptyExpression()
            return Or(left: newLeft, right: newRight, id: id)
        case "not":
            let newContent = content?.returnExpression() ?? EmptyExpression()
            return Not(content: newContent, id: id)
        default:
            return Expression()
        }
    }
}
