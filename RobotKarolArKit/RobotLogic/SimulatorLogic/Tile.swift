//
//  Tile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

class Tile {
    private var blocks: [Block] = []
    
    func getBlocks() -> [Block] {
        return self.blocks
    }
    
    func addBlock(_ block: BlockTyp, tileWidth: Float, tileHight: Float, worldEntity: Entity, tilePosition: (Int, Int)) {
        let newBlock = Block(blockTyp: block, blockNumber: self.blocks.count)
        newBlock.createArBlock(position: tilePosition, tileWidth: tileWidth, tileHight: tileHight, worldEntity: worldEntity)
        blocks.append(newBlock)
    }
    
    func removeBlock(worldEntity: Entity) -> Block? {
        guard let block = blocks.popLast() else {
            return nil
        }
        
        worldEntity.removeChild(block.blockEntity)
        return block
    }
}
