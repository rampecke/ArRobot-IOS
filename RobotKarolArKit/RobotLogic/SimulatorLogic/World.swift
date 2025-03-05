//
//  World.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

@Observable
class World {
    private var tiles: [[Tile]]
    private var width: Int
    private var length: Int
    private var robot: Robot
    
    let tileHeight: Float = 0.001
    let tileWidth: Float =  0.05
    let lineWidth: Float = 0.002
    var worldEntity: Entity = Entity()
    var arWorldWasCreated: Bool = false
    
    init(width: Int, length: Int) {
        self.width = width
        self.length = length
        self.robot = Robot(facingDirection: Direction.SOUTH, position: (0,0))
        
        var createTiles : [[Tile]]  = []
        for _ in 0..<length {
            var tilesRow: [Tile] = []
            for _ in 0..<width {
                tilesRow.append(Tile())
            }
            createTiles.append(tilesRow)
        }
        self.tiles = createTiles
    }
    
    func getLength() -> Int {
        self.length
    }
    
    private func createTiles() -> [[Tile]] {
        var createTiles : [[Tile]]  = []
        for _ in 0..<length {
            var tilesRow: [Tile] = []
            for _ in 0..<width {
                tilesRow.append(Tile())
            }
            createTiles.append(tilesRow)
        }
        
        return createTiles
    }
    
    func step() -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            robot.step(tileWidth: tileWidth, tileHight: tileHeight, tilesInFront: tile.getBlocks().count)
            return true
        } else {
            return false
        }
    }
    
    func place(block: BlockTyp) -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            
            tile.addBlock(block, tileWidth: tileWidth, tileHight: tileHeight, worldEntity: worldEntity, tilePosition: positionInFront)
            return true
        } else {
            return false
        }
    }
    
    func lift() -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            
            let block = tile.removeBlock(worldEntity: worldEntity)

            if(block == nil) {
                return false
            } else {
                return true
            }
        } else {
            return false;
        }
    }
    
    func turnLeft() -> Bool {
        robot.turnLeft()
        return true
    }
    
    func turnRight() -> Bool {
        robot.turnRight()
        return true
    }
    
    private func nextTileExists() -> Bool {
        switch robot.getFacingDirection() {
        case .NORTH:
            return robot.getPosition().1 - 1 >= 0
        case .EAST:
            return robot.getPosition().0 + 1 < width
        case .SOUTH:
            return robot.getPosition().1 + 1 < length
        case .WEST:
            return robot.getPosition().0 - 1 >= 0
        }
    }
    
    func resetWorld() {
        let anchor = worldEntity.anchor
        
        //Reset Robot and Field
        self.robot = Robot(facingDirection: Direction.SOUTH, position: (0,0))
        self.tiles = createTiles()
        
        //Reset ArWorld
        anchor?.removeChild(worldEntity)
        worldEntity = Entity()
        worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        createArWorld()
        anchor?.addChild(worldEntity)
    }
    
    func createArWorld() {
        //Grid
        let floorTileMesh = MeshResource.generateBox(width: tileWidth-lineWidth, height: tileHeight, depth: tileWidth-lineWidth)
        let floorTileMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        
        let verticalLineMesh = MeshResource.generateBox(width: lineWidth, height: tileHeight, depth: tileWidth*Float(length)+lineWidth)
        let horizontalLineMesh = MeshResource.generateBox(width: tileWidth*Float(width)+lineWidth, height: tileHeight, depth: lineWidth)
        let lineMaterial = SimpleMaterial(color: .black, roughness: 0.5, isMetallic: true)
        
        let offsetWidth = ((tileWidth*Float(length)) / 2) - tileWidth/2
        let offsetLength = ((tileWidth*Float(width)) / 2) - tileWidth/2
        
        for i in 0...width {
            let entityVertical = ModelEntity(mesh: verticalLineMesh, materials: [lineMaterial])
            entityVertical.position = [(Float(i)*tileWidth)-tileWidth/2,0,offsetWidth]
            worldEntity.addChild(entityVertical)
        }
        
        for i in 0...length {
            let entityHorizontal = ModelEntity(mesh: horizontalLineMesh, materials: [lineMaterial])
            entityHorizontal.position = [offsetLength,0,(Float(i)*tileWidth)-tileWidth/2]
            worldEntity.addChild(entityHorizontal)
        }
        
        
        for i in 0...width-1 {
            for j in 0...length-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [floorTileMaterial])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                worldEntity.addChild(entity)
            }
        }
        
        robot.createArRobot(tileWidth: tileWidth, tileHeight: tileHeight, worldEntity: worldEntity)
    }
    
    func anchorWorld(arView: ARView, anchor: AnchorEntity) {
        if(!arWorldWasCreated) {
            createArWorld()
            arWorldWasCreated = true
        }
        //Reposition because of Offset
        worldEntity.position = [-(tileWidth * Float(width)/2), 0, -(tileWidth * Float(length)/2)]
        anchor.addChild(self.worldEntity)
        arView.scene.addAnchor(anchor)
    }
}
