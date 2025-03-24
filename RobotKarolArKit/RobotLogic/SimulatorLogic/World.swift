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
    
    var arModelLoader: ArModelLoader
    
    var exerciseTiles: [[Tile]]
    
    init(width: Int, length: Int, exerciseTiles: [[Tile]] = [[]], arModelLoader: ArModelLoader) {
        self.width = width
        self.length = length
        self.robot = Robot(facingDirection: Direction.SOUTH, position: (0,0), arModelLoader: arModelLoader)
        self.arModelLoader = arModelLoader
        
        var createTiles : [[Tile]]  = []
        for _ in 0..<width {
            var tilesRow: [Tile] = []
            for _ in 0..<length {
                tilesRow.append(Tile(arModelLoader: arModelLoader))
            }
            createTiles.append(tilesRow)
        }
        self.tiles = createTiles
        self.exerciseTiles = exerciseTiles
    }
    
    func getLength() -> Int {
        self.length
    }
    
    func getWidth() -> Int {
        self.width
    }
    
    func getTiles() -> [[Tile]] {
        self.tiles
    }
    
    func exerciseSuccess() -> Bool {
        //If they have diffrent sizes they can't be the same
        guard self.tiles.count == self.exerciseTiles.count else {
            return false
        }
        guard self.tiles[0].count == self.exerciseTiles[0].count else {
            return false
        }
        
        //Check each tile
        for i in 0..<width {
            for j in 0..<length {
                if self.tiles[i][j] != self.exerciseTiles[i][j] {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func createTiles() -> [[Tile]] {
        var createTiles : [[Tile]]  = []
        for _ in 0..<width {
            var tilesRow: [Tile] = []
            for _ in 0..<length {
                tilesRow.append(Tile(arModelLoader: arModelLoader))
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
    
    func stepWithoutAr() -> Bool {
        if(nextTileExists()) {
            robot.stepWithoutAr()
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
            
            //Remove Block from exercise if there is one
            if exerciseTiles.count > positionInFront.0 && exerciseTiles[0].count > positionInFront.1 {
                let exerciseTile = exerciseTiles[positionInFront.0][positionInFront.1]
                let placedBlockPosition = tile.getBlocks().count - 1
                if exerciseTile.getBlocks().count > placedBlockPosition {
                    exerciseTile.getBlocks()[placedBlockPosition].removeArBlock(worldEntity: self.worldEntity)
                }
            }
            return true
        } else {
            return false
        }
    }
    
    func placeWithoutAr(block: BlockTyp) -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            
            tile.addBlockWithoutAR(block)
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
                //If block was removed check if we need to add ExerciseBlock back
                if exerciseTiles.count > positionInFront.0 && exerciseTiles[0].count > positionInFront.1 {
                    let exerciseTile = exerciseTiles[positionInFront.0][positionInFront.1]
                    let removedBlockPosition = tile.getBlocks().count
                    if exerciseTile.getBlocks().count > removedBlockPosition {
                        exerciseTile.getBlocks()[removedBlockPosition].createArBlock(position: positionInFront, tileWidth: self.tileWidth, tileHight: self.tileHeight, worldEntity: self.worldEntity, isTransparent: true)
                    }
                }
                
                return true
            }
        } else {
            return false;
        }
    }
    
    func liftWithoutAR() -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            
            let block = tile.removeBlockWithoutAr()

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
    
    func turnLeftWithoutAR() -> Bool {
        robot.turnLeftWithoutAr()
        return true
    }
    
    func turnRight() -> Bool {
        robot.turnRight()
        return true
    }
    
    func turnRightWithoutAR() -> Bool {
        robot.turnRightWithoutAr()
        return true
    }
    
    func checkRobotIsFacingDirection(direction: Direction) -> Bool {
        return robot.getFacingDirection() == direction
    }
    
    
    func nextTileExists() -> Bool {
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
    
    func nextTileHasBlock() -> Bool {
        if(nextTileExists()) {
            let positionInFront = robot.positionInFront()
            let tile = tiles[positionInFront.0][positionInFront.1]
            return !tile.getBlocks().isEmpty
        } else {
            return false
        }
    }
    
    //MARK: - AR Functions
    
    func drawWorldState(isTransparent: Bool = false) {
        //draw the robot at correct position
        let roboPosition = robot.getPosition()
        let tile = tiles[roboPosition.0][roboPosition.1]
        robot.drawRobotAtPosition(tileWidth: self.tileWidth, tileHight: self.tileHeight, tilesOnMyPosition: tile.getBlocks().count)
        
        //draw all blocks
        for i in 0..<width {
            for j in 0..<length {
                let tile = tiles[i][j]
                tile.drawAllMyBlocks(tileWidth: self.tileWidth, tileHight: self.tileHeight, worldEntity: self.worldEntity, tilePosition: (i,j), isTransparent: isTransparent)
            }
        }
    }
    
    func drawExerciseTiles() {
        //draw all blocks
        for i in 0..<exerciseTiles.count {
            for j in 0..<exerciseTiles[0].count {
                let tile = exerciseTiles[i][j]
                tile.drawAllMyBlocks(tileWidth: self.tileWidth, tileHight: self.tileHeight, worldEntity: self.worldEntity, tilePosition: (i,j), isTransparent: true)
            }
        }
    }
    
    func resetWorld() {
        let anchor = worldEntity.anchor
        
        //Reset Robot and Field
        self.robot = Robot(facingDirection: Direction.SOUTH, position: (0,0), arModelLoader: arModelLoader)
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
        
        //If i have a exerciseTileMatrix i also want to render it
        if !exerciseTiles.isEmpty {
            drawExerciseTiles()
        }
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
    
    func setWidth(newWidth: Int, viewModel: ExerciseEditorViewModel) {
        width = newWidth
        viewModel.reset()
        viewModel.executeAllWithoutDispatcher()
    }
    
    func setLength(newLength: Int, viewModel: ExerciseEditorViewModel) {
        length = newLength
        viewModel.reset()
        viewModel.executeAllWithoutDispatcher()
    }
}
