//
//  ArModelLoader.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 22.03.25.
//

import Foundation
import RealityKit
import ARKit

//Needed so we can preload the models and don't have to load the model for each block
class ArModelLoader {
    private var robotModel: Entity?
    private var grasBlockModel: Entity?
    private var waterBlockModel: Entity?
    private var stoneBlockModel: Entity?
    
    init() {
        self.robotModel = loadModel(modelName: "RobotVersion7")
        self.grasBlockModel = loadModel(modelName: "GrasBlockVersion4")
        self.waterBlockModel = loadModel(modelName: "WaterBlockVersion1")
        self.stoneBlockModel = loadModel(modelName: "StoneBlockVersion1")
    }
    
    private func loadModel(modelName: String) -> Entity? {
        guard let entity = try? Entity.load(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        
        return entity
    }
    
    func returnCopyOf(modelType: PreloadModelType) -> Entity? {
        guard let entity = switch modelType {
        case .robot:
            robotModel?.clone(recursive: true)
        case .grasBlock:
            grasBlockModel?.clone(recursive: true)
        case .waterBlock:
            waterBlockModel?.clone(recursive: true)
        case .stoneBlock:
            stoneBlockModel?.clone(recursive: true)
        } else {
            print("Failed to load model")
            return nil
        }

        return entity
    }
}

enum PreloadModelType {
    case robot, grasBlock, waterBlock, stoneBlock
}
