//
//  Robot.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 23.03.24.
//

import Foundation

class Robot {
    private var facingDirection: Direction
    private var position: (Int, Int)
    
    init(facingDirection: Direction, position: (Int, Int)) {
        self.facingDirection = facingDirection
        self.position = position
    }
}
