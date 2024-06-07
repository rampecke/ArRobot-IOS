//
//  World.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation

class World {
    private var field: [[Tile]]
    private var width: Int
    private var length: Int
    private var robot: Robot
    
    init(width: Int, length: Int) {
        self.field = Array(repeating: Array(repeating: Tile() , count: width), count: length)
        self.width = width
        self.length = length
        self.robot = Robot(facingDirection: Direction.NORTH, position: (0,0))
    }
    
    func getWidth() -> Int {
        self.width
    }
    
    func getLenght() -> Int {
        self.length
    }
}
