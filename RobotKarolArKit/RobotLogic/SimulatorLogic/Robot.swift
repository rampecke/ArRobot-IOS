//
//  Robot.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 23.03.24.
//

import Foundation
import RealityKit

@Observable
class Robot {
    private var facingDirection: Direction
    private var position: (Int, Int)
    
    private var robotEntity: Entity = Entity()
    
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
        robotEntity.position = [tileWidth*Float(position.0), tileHight + (tileWidth * Float(tilesInFront)),tileWidth*Float(position.1)]
    }
    
    func stepWithoutAr() {
        position = positionInFront()
    }
    
    func turnLeft() {
        var rotationAngle: Float = 0
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.WEST
            rotationAngle = Float.pi / 2
        case .EAST:
            facingDirection = Direction.NORTH
        case .SOUTH:
            facingDirection = Direction.EAST
            rotationAngle = 3 * Float.pi / 2
        case .WEST:
            facingDirection = Direction.SOUTH
            rotationAngle = Float.pi
        }
        
        robotEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
    
    func turnLeftWithoutAr() {
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
    }
    
    func turnRight() {
        var rotationAngle: Float = 0
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.EAST
            rotationAngle = 3 * Float.pi / 2
        case .EAST:
            facingDirection = Direction.SOUTH
            rotationAngle = Float.pi
        case .SOUTH:
            facingDirection = Direction.WEST
            rotationAngle = Float.pi / 2
        case .WEST:
            facingDirection = Direction.NORTH
        }
        
        robotEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
    
    func turnRightWithoutAr() {
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
        //TODO: MOVE ViewLoader to ViewModel
        let modelLoader = ArModelLoader()
        guard let newRobotEntity = modelLoader.returnCopyOf(modelType: .robot) else {
            return
        }
        
        robotEntity = newRobotEntity
        robotEntity.scale *= 2.5
        robotEntity.position = [tileWidth*Float(position.0),tileHeight,tileWidth*Float(position.1)]
        //The model is the wrong way so we need to initialy turn it around
        robotEntity.transform.rotation = simd_quatf(angle: .pi, axis: SIMD3<Float>(0, 1, 0))
        worldEntity.addChild(robotEntity)
    }
    
    func deleteRoboEntities() {
        robotEntity.children.removeAll()
    }
    
    func drawRobotAtPosition(tileWidth: Float, tileHight: Float, tilesOnMyPosition: Int) {
        robotEntity.position = [tileWidth*Float(self.position.0), tileHight + (tileWidth * Float(tilesOnMyPosition)),tileWidth*Float(self.position.1)]
        turnRoboInFacingDirection()
    }
    
    private func turnRoboInFacingDirection() {
        var rotationAngle: Float
        switch facingDirection {
        case .NORTH:
            rotationAngle = Float.pi
        case .EAST:
            rotationAngle = Float.pi / 2
        case .SOUTH:
            rotationAngle = 0
        case .WEST:
            rotationAngle = 3 * Float.pi / 2
        }
        
        robotEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
}
