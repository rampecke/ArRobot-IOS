//
//  PlaceWater.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import Foundation

class PlaceWater: Statement {
    override init() {
        super.init()
        self.type = "placeWater"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    override func accept(visitor: Visitor) {
        visitor.visit(placeWater: self)
    }
}
