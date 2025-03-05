//
//  ARSimulator.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import SwiftUI
import RealityKit

struct ARSimulator: View {
    @Bindable var viewModel: CodeEditorViewModel
    
    var body: some View {
        VStack{
            ARViewContainer(world: viewModel.world).edgesIgnoringSafeArea(.all)
            ArViewControlBar(viewModel: viewModel)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var world: World
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        //let anchor = AnchorEntity(plane: .horizontal, classification: .table)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0, 0)))
        world.anchorWorld(arView: arView, anchor: anchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}
