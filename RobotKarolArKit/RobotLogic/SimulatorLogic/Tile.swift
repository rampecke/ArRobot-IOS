//
//  Tile.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.24.
//

import Foundation

class Tile {
    private var blocks: [Block] = []
    
    func getBlocks() -> [Block] {
        return self.blocks
    }
    
    func addBlock(_ block: Block) {
        blocks.append(block)
    }
    
    func removeBlock() -> Block? {
        blocks.popLast()
    }
}
