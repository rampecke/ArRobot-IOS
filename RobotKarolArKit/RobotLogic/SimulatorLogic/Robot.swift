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
        var rotationAngle: Float = 0
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.WEST
            rotationAngle = 3 * Float.pi / 2
        case .EAST:
            facingDirection = Direction.NORTH
            rotationAngle = Float.pi
        case .SOUTH:
            facingDirection = Direction.EAST
            rotationAngle = Float.pi / 2
        case .WEST:
            facingDirection = Direction.SOUTH
        }
        
        robotEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
    
    func turnRight() {
        var rotationAngle: Float = 0
        switch facingDirection {
        case .NORTH:
            facingDirection = Direction.EAST
            rotationAngle = Float.pi / 2
        case .EAST:
            facingDirection = Direction.SOUTH
        case .SOUTH:
            facingDirection = Direction.WEST
            rotationAngle = 3 * Float.pi / 2
        case .WEST:
            facingDirection = Direction.NORTH
            rotationAngle = Float.pi
        }
        
        robotEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
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
        
        //Face
        let robotFaceMesh = MeshResource.generateBox(width: robotWidth, height: robotHeight/2, depth: 0.001)
        let robotFaceMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
        let robotFaceEntity = ModelEntity(mesh: robotFaceMesh, materials: [robotFaceMaterial])
        
        robotEntity.position = [tileWidth*Float(position.0),robotHeight/2 + tileHeight,tileWidth*Float(position.1)]
        robotFaceEntity.position = [tileWidth*Float(position.0),(robotHeight/2)/2 + tileHeight ,tileWidth*Float(position.1) + robotWidth/2]
        robotEntity.addChild(robotFaceEntity)
        
        worldEntity.addChild(robotEntity)
    }
}
