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
            HStack{
                Button("nextMove") {
                    viewModel.next()
                }
                Spacer()
                Button("executeAll") {
                    viewModel.executeAll()
                }
                Spacer()
                Button("Reset") {
                    viewModel.reset()
                }
            }
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
        let lightAnchor = AnchorEntity(world: [0,0,0])
        lightAnchor.addChild(pointLight)
        arView.scene.addAnchor(lightAnchor)
        
        
        //Createworld
        let worldAnchor = AnchorEntity(world: [0,0,0])
        world.anchorWorld(arView: arView, anchor: worldAnchor)
        
        //Camera
        let camera = PerspectiveCamera()
        let cameraAnchor = AnchorEntity(world: [0,0.2,0.7])
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}

#Preview {
    NonArView(viewModel: CodeEditorViewModel())
}
