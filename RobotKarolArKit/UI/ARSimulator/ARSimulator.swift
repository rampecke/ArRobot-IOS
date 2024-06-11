//
//  ARSimulator.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import SwiftUI
import RealityKit

struct ARSimulator: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        arView.scene.anchors.removeAll()
        
        createField(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    private func createField(arView: ARView) {
        //Grid
        let gridSize = 6
        let tileHeight: Float = 0.001
        let tileWidth: Float =  0.05
        
        let lineWidth: Float = 0.002
        
        let floorTileMesh = MeshResource.generateBox(width: tileWidth-lineWidth, height: tileHeight, depth: tileWidth-lineWidth)
        let floorTileMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        let anchor = AnchorEntity(plane: .horizontal, classification: .table)
        
        let verticalLineMesh = MeshResource.generateBox(width: lineWidth, height: tileHeight, depth: tileWidth*Float(gridSize)+lineWidth)
        let horizontalLineMesh = MeshResource.generateBox(width: tileWidth*Float(gridSize)+lineWidth, height: tileHeight, depth: lineWidth)
        let lineMaterial = SimpleMaterial(color: .black, roughness: 0.5, isMetallic: true)
        
        let offset = ((tileWidth*Float(gridSize)) / 2) - tileWidth/2
        for i in 0...gridSize {
            let entity = ModelEntity(mesh: verticalLineMesh, materials: [lineMaterial])
            entity.position = [(Float(i)*tileWidth)-tileWidth/2,0,offset]
            anchor.addChild(entity)
            
            let entity2 = ModelEntity(mesh: horizontalLineMesh, materials: [lineMaterial])
            entity2.position = [offset,0,(Float(i)*tileWidth)-tileWidth/2]
            anchor.addChild(entity2)
        }
        
        
        for i in 0...gridSize-1 {
            for j in 0...gridSize-1 {
                let entity = ModelEntity(mesh: floorTileMesh, materials: [floorTileMaterial])
                entity.position = [tileWidth*Float(i),0,tileWidth*Float(j)]
                anchor.addChild(entity)
            }
        }
        
        
        arView.scene.addAnchor(anchor)
    }
    
}

#Preview {
    ARSimulator()
}
