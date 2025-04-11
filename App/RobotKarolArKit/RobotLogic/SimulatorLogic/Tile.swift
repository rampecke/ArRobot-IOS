//
//  Tile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

@Observable
class Tile: Codable, Equatable {
    private var blocks: [Block]
    
    init(blocks: [Block] = []) {
        self.blocks = blocks
    }
    
    //Decode and Encode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blocks = try container.decode([Block].self, forKey: .blocks)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(blocks, forKey: .blocks)
    }

    private enum CodingKeys: String, CodingKey {
        case blocks
    }
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        guard lhs.blocks.count == rhs.blocks.count else { return false }
        
        for (block1, block2) in zip(lhs.blocks, rhs.blocks) {
            if block1.blockTyp != block2.blockTyp || block1.blockNumber != block2.blockNumber {
                return false
            }
        }
        
        return true
    }
    
    func getBlocks() -> [Block] {
        return self.blocks
    }
    
    func addBlock(_ block: BlockTyp, tileWidth: Float, tileHight: Float, worldEntity: Entity, tilePosition: (Int, Int)) {
        let newBlock = Block(blockTyp: block, blockNumber: self.blocks.count)
        newBlock.createArBlock(position: tilePosition, tileWidth: tileWidth, tileHight: tileHight, worldEntity: worldEntity)
        blocks.append(newBlock)
    }
    
    func addBlockWithoutAR(_ block: BlockTyp) {
        let newBlock = Block(blockTyp: block, blockNumber: self.blocks.count)
        blocks.append(newBlock)
    }
    
    func removeBlock(worldEntity: Entity) -> Block? {
        guard let block = blocks.popLast() else {
            return nil
        }
        
        worldEntity.removeChild(block.blockEntity)
        return block
    }
    
    func removeBlockWithoutAr() -> Block? {
        guard let block = blocks.popLast() else {
            return nil
        }
        return block
    }
    
    func drawAllMyBlocks(tileWidth: Float, tileHight: Float, worldEntity: Entity, tilePosition: (Int, Int), isTransparent: Bool = false) {
        for block in self.blocks {
            block.createArBlock(position: tilePosition, tileWidth: tileWidth, tileHight: tileHight, worldEntity: worldEntity, isTransparent: isTransparent)
        }
    }
}
