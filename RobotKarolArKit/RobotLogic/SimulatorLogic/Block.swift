//
//  Block.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

@Observable
class Block {
    var blockTyp: BlockTyp
    var blockEntity: Entity = Entity()
    var blockNumber: Int
    
    init(blockTyp: BlockTyp, blockNumber: Int) {
        self.blockTyp = blockTyp
        self.blockNumber = blockNumber
    }
    
    func createArBlock(position: (Int, Int), tileWidth: Float, tileHight: Float, worldEntity: Entity) {
        //TODO: USE REAL MODLES
        let blockMesh = MeshResource.generateBox(width: tileWidth, height: tileWidth, depth: tileWidth)
        let blockMaterial = switch blockTyp {
        case .WATER:
            SimpleMaterial(color: .blue, isMetallic: false)
        case .GRAS:
            SimpleMaterial(color: .green, isMetallic: false)
        case .STONE:
            SimpleMaterial(color: .gray, isMetallic: false)
        }
        
        blockEntity = ModelEntity(mesh: blockMesh, materials: [blockMaterial])
        
        blockEntity.position = [tileWidth*Float(position.0),tileWidth/2 + tileHight + Float(blockNumber) * tileWidth,tileWidth*Float(position.1)]
        
        worldEntity.addChild(blockEntity)
    }
}

enum BlockTyp {
    case WATER, GRAS, STONE;
}
