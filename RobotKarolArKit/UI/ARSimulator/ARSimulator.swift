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

struct ARViewContainer: UIViewRepresentable {
    var world: World
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        //let anchor = AnchorEntity(plane: .horizontal, classification: .table)
        let anchor = AnchorEntity(plane: .horizontal)
        world.anchorWorld(arView: arView, anchor: anchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}

#Preview {
    ARSimulator(viewModel: CodeEditorViewModel())
}
