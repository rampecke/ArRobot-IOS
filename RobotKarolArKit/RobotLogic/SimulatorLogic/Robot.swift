//
//  Robot.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 23.03.24.
//

import Foundation
import RealityKit

class Robot {
    private var facingDirection: Direction
    private var position: (Int, Int)
    
    private var robotEntity: Entity = Entity()
    private let robotWidth: Float = 0.03
    private let robotHeight: Float = 0.08
    
    init(facingDirection: Direction, position: (Int, Int)) {
        self.facingDirection = facingDirection
        self.position = position
    }
    
    func getPosition() -> (Int, Int) {
        self.position
    }
    
    func getFacingDirection() -> Direction {
        self.facingDirection
    }
    
    func step(tileWidth: Float, tileHight: Float, tilesInFront: Int) {
        position = positionInFront()
        //Move ArEntity
        //TODO: move instead of new position
        robotEntity.position = [tileWidth*Float(position.0),robotHeight/2 + tileHight + (tileWidth * Float(tilesInFront)),tileWidth*Float(position.1)]
    }
    
    func turnLeft() {
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.WEST
        case .EAST:
            facingDirection = Direction.NORTH
        case .SOUTH:
            facingDirection = Direction.EAST
        case .WEST:
            facingDirection = Direction.SOUTH
        }
        
        //TODO: TURN ENTITY
    }
    
    func turnRight() {
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.EAST
        case .EAST:
            facingDirection = Direction.SOUTH
        case .SOUTH:
            facingDirection = Direction.WEST
        case .WEST:
            facingDirection = Direction.NORTH
        }
        
        //TODO: TURN ENTITY
    }
    
    func positionInFront() -> (Int, Int) {
        switch facingDirection {
            case .NORTH:
                return (position.0,position.1 - 1)
            case .EAST:
                return (position.0 + 1,position.1)
            case .SOUTH:
                return (position.0,position.1 + 1)
            case .WEST:
                return (position.0 - 1,position.1)
        }
    }
    
    func createArRobot(tileWidth: Float, tileHeight: Float, worldEntity: Entity) {
        //Todo: Instead use a model
        let robotMesh = MeshResource.generateBox(width: robotWidth, height: robotHeight, depth: robotWidth)
        let robotMaterial = SimpleMaterial(color: .blue, isMetallic: false)
        robotEntity = ModelEntity(mesh: robotMesh, materials: [robotMaterial])
        
        robotEntity.position = [tileWidth*Float(position.0),robotHeight/2 + tileHeight,tileWidth*Float(position.1)]
        
        worldEntity.addChild(robotEntity)
    }
}
