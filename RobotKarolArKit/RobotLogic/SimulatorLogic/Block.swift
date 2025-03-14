//
//  Block.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

@Observable
class Block: Codable {
    var blockTyp: BlockTyp
    var blockEntity: Entity = Entity()
    var blockNumber: Int
    
    init(blockTyp: BlockTyp, blockNumber: Int) {
        self.blockTyp = blockTyp
        self.blockNumber = blockNumber
    }
    
    func createArBlock(position: (Int, Int), tileWidth: Float, tileHight: Float, worldEntity: Entity, isTransparent: Bool = false) {
        //TODO: USE REAL MODLES
        let blockMesh = MeshResource.generateBox(width: tileWidth, height: tileWidth, depth: tileWidth)
        let blockMaterial = switch blockTyp {
        case .WATER:
            SimpleMaterial(color: .blue.withAlphaComponent(isTransparent ? 0.35 : 1.0), isMetallic: false)
        case .GRAS:
            SimpleMaterial(color: .green.withAlphaComponent(isTransparent ? 0.35 : 1.0), isMetallic: false)
        case .STONE:
            SimpleMaterial(color: .gray.withAlphaComponent(isTransparent ? 0.35 : 1.0), isMetallic: false)
        }
        
        blockEntity = ModelEntity(mesh: blockMesh, materials: [blockMaterial])
        
        blockEntity.position = [tileWidth*Float(position.0),tileWidth/2 + tileHight + Float(blockNumber) * tileWidth,tileWidth*Float(position.1)]
        
        worldEntity.addChild(blockEntity)
    }
    
    func removeArBlock(worldEntity: Entity) {
        worldEntity.removeChild(blockEntity)
        blockEntity = Entity()
    }
    
    //Decode and Encode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blockTyp = try container.decode(BlockTyp.self, forKey: .blockType)
        self.blockNumber = try container.decode(Int.self, forKey: .blockNumber)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(blockTyp, forKey: .blockType)
        try container.encode(blockNumber, forKey: .blockNumber)
        self.blockEntity = Entity()
    }

    private enum CodingKeys: String, CodingKey {
        case blockType, blockNumber
    }
}

enum BlockTyp: Codable {
    case WATER, GRAS, STONE;
}
