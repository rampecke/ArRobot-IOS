//
//  ARSimulator.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARSimulator: View {
    @Bindable var viewModel: CodeEditorViewModel
    @State private var wasPlaced: Bool = false
    
    var body: some View {
        ZStack{
            ARViewContainer(world: viewModel.world, wasPlaced: $wasPlaced)
                .edgesIgnoringSafeArea(.all)

            if wasPlaced {
                ArViewControlBar(viewModel: viewModel)
            } else {
                VStack {
                    Text("Move your device to find a surface")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        wasPlaced = true
                    }) {
                        Text("Place Here")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }

        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var world: World
    @Binding var wasPlaced: Bool
    
    func makeCoordinator() -> Coordinator {
        let newCoordinator = Coordinator(parent: self, wasPlaced: $wasPlaced)
        return newCoordinator
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.confirmPlacement()
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        uiView.session.pause() // Stop AR session when view is removed
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var placementIndicator: Entity?
        var confirmedAnchor: AnchorEntity?
        @Binding var wasPlaced: Bool

        init(parent: ARViewContainer, wasPlaced: Binding<Bool>) {
            self.parent = parent
            _wasPlaced = wasPlaced
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let arView = arView, !wasPlaced else { return }
            
            let results = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal)
            if let firstResult = results.first {
                let position = simd_make_float3(firstResult.worldTransform.columns.3)
                
                if placementIndicator == nil {
                    let indicator = createPlacementIndicator()
                    arView.scene.addAnchor(indicator)
                    placementIndicator = indicator
                }
                
                placementIndicator?.position = position
            }
        }

        func createPlacementIndicator() -> AnchorEntity {
            let anchor = AnchorEntity()
            let box = ModelEntity(mesh: .generateBox(width: 0.05, height: 0.001, depth: 0.05), materials: [SimpleMaterial(color: .white, roughness: 0.5, isMetallic: false)])
            box.generateCollisionShapes(recursive: true)
            anchor.addChild(box)
            return anchor
        }

        func confirmPlacement() {
            guard let arView = arView, let placementIndicator = placementIndicator else { return }
            
            let anchor = AnchorEntity(world: placementIndicator.position)
            parent.world.anchorWorld(arView: arView, anchor: anchor)
            confirmedAnchor = anchor
            arView.scene.addAnchor(anchor)

            // Remove indicator after confirming
            self.placementIndicator?.removeFromParent()
            self.placementIndicator = nil
        }
    }
}
