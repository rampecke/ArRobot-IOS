//
//  NonArView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import SwiftUI
import RealityKit

struct NonArView: View {
    @Bindable var viewModel: CodeEditorViewModel
    
    var body: some View {
        VStack{
            NonARViewContainer(world: viewModel.world).edgesIgnoringSafeArea(.all)
            ArViewControlBar(viewModel: viewModel)
        }
    }
}

struct NonARViewContainer: UIViewRepresentable {
    var world: World
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        
        //Create Lighting
        let pointLight = PointLight()
        pointLight.light.intensity = 10000
        let lightAnchor = AnchorEntity(world: [0,1,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        
        //Createworld
        let worldAnchor = AnchorEntity(world: [0,0,0])
        world.anchorWorld(arView: arView, anchor: worldAnchor)
        
        //Camera
        let camera = PerspectiveCamera()
        let cameraAnchor = AnchorEntity(world: [0,0.2,world.tileWidth*Float(world.getLength()) + 0.4])
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}
