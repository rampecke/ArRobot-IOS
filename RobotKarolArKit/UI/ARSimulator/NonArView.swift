//
//  NonArView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import SwiftUI
import RealityKit

struct NonArView: View {
    var body: some View {
        NonARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct NonARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        
        //Create Lighting
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        //Simulate Floor
        let planeMesh = MeshResource.generatePlane(width: 10, depth: 10)
        let planeMaterial = SimpleMaterial(color: .blue, roughness: 0.5, isMetallic: true)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        let planeAnchor = AnchorEntity(world: [0,0,0])
        planeAnchor.addChild(planeEntity)
        arView.scene.addAnchor(planeAnchor)
        
        //LineOnFloor
        let lineMesh = MeshResource.generateBox(width: 0.1, height: 0.001, depth: 10)
        let lineMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        let lineEntity = ModelEntity(mesh: lineMesh, materials: [lineMaterial])
        let lineAnchor = AnchorEntity(world: [0,0,0])
        lineAnchor.addChild(lineEntity)
        arView.scene.addAnchor(lineAnchor)
        //LineOnFloor
        let lineEntity2 = ModelEntity(mesh: lineMesh, materials: [lineMaterial])
        let lineAnchor2 = AnchorEntity(world: [0.2,0,0])
        lineAnchor2.addChild(lineEntity2)
        arView.scene.addAnchor(lineAnchor2)
        
        //Camera
        let camera = PerspectiveCamera()
        let cameraAnchor = AnchorEntity(world: [0,1,1])
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        createField(uiView: uiView)
    }
    
    private func createField(uiView: ARView) {
        
    }
    
}

#Preview {
    NonArView()
}
