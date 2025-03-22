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
    
    init() {
        self.robotModel = loadModel(modelName: "RobotVersion7")
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
        } else {
            print("Failed to load model")
            return nil
        }

        return entity
    }
}

enum PreloadModelType {
    case robot
}
