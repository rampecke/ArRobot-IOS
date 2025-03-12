//
//  Tile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation
import RealityKit

@Observable
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
    
    func addBlockWithoutAR(_ block: BlockTyp) {
        let newBlock = Block(blockTyp: block, blockNumber: self.blocks.count-1)
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
