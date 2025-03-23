//
//  Block.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit
import UIKit

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
        //TODO: Move ModelLoader
        let modelLoader = ArModelLoader()

        if blockTyp == .GRAS {
            guard let newGrasBlock = modelLoader.returnCopyOf(modelType: .grasBlock) else {
                return
            }
            
            blockEntity = newGrasBlock
        } else if blockTyp == .WATER{
            guard let newWaterBlock = modelLoader.returnCopyOf(modelType: .waterBlock) else {
                return
            }
             
            blockEntity = newWaterBlock
        } else if blockTyp == .STONE {
            guard let newStoneBlock = modelLoader.returnCopyOf(modelType: .stoneBlock) else {
                return
            }
             
            blockEntity = newStoneBlock
        }
        
        if isTransparent {
            if #available(iOS 18.0, *) {
                let opacityComponent = OpacityComponent(opacity: 0.5)
                blockEntity.components.set(opacityComponent)
            } else {
                //Not a nice way, but there is no other option in realityKit before iOS18
                if let modelEntity = blockEntity as? ModelEntity {
                    var materials = modelEntity.model?.materials ?? []
                    for (index, material) in materials.enumerated() {
                        if var pbMaterial = material as? PhysicallyBasedMaterial {
                            pbMaterial.blending = .transparent(opacity: .init(floatLiteral: 0.5))
                            materials[index] = pbMaterial
                        }
                    }
                    
                    modelEntity.model?.materials = materials
                }
            }
        }
        
        blockEntity.scale =  SIMD3<Float>(tileWidth/2, tileWidth/2, tileWidth/2)
        blockEntity.position = [tileWidth*Float(position.0), tileHight + Float(blockNumber) * tileWidth,tileWidth*Float(position.1)]
        
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
