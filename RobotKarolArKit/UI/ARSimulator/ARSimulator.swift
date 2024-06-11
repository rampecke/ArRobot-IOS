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
                Button("PlaceWater") {
                    viewModel.world.place(block: BlockTyp.WATER)
                }
                Spacer()
                Button("PlaceGrass") {
                    viewModel.world.place(block: BlockTyp.GRAS)
                }
                Spacer()
                Button("PlaceStone") {
                    viewModel.world.place(block: BlockTyp.STONE)
                }
                Spacer()
                Button("Lift") {
                    viewModel.world.lift()
                }
                Spacer()
                Button("Step") {
                    viewModel.world.step()
                }
                Spacer()
                Button("TurnRight") {
                    viewModel.world.turnRight()
                }
                Spacer()
                Button("TurnLeft") {
                    viewModel.world.turnLeft()
                }
                Spacer()
                Button("Reset") {
                    viewModel.world.resetWorld()
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var world: World
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal, classification: .table)
        world.anchorWorld(arView: arView, anchor: anchor)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}

#Preview {
    ARSimulator(viewModel: CodeEditorViewModel())
}
