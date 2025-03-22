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
    private var robotModel: ModelEntity?
    
    init() {
        self.robotModel = loadModel(modelName: "RobotVersion1")
    }
    
    private func loadModel(modelName: String) -> ModelEntity? {
        guard let modelEntity = try? ModelEntity.loadModel(named: modelName) else {
            print("Failed to load model")
            return nil
        }
        return modelEntity
    }
    
    func returnCopyOf(modelType: PreloadModelType) -> ModelEntity? {
        guard let modelEntity = switch modelType {
        case .robot:
            robotModel?.clone(recursive: true)
        } else {
            print("Failed to load model")
            return nil
        }
        
        return modelEntity
    }
}

enum PreloadModelType {
    case robot
}
