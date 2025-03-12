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
    var isInExerciseEditor: Bool
    
    var body: some View {
        ZStack{
            NonARViewContainer(viewModel: viewModel).edgesIgnoringSafeArea(.all)
            if isInExerciseEditor {
                VStack {
                    Spacer()
                    if let messageKey = viewModel.executionVisitor.executionMessage {
                        ExecutionStatusLable(executionMessage: messageKey, lableType: .failed, longMessage: true)
                    } else if viewModel.executionVisitor.finishedExecution {
                        ExecutionStatusLable(executionMessage: nil, lableType: .sucessfull, longMessage: true)
                    }
                }.background(.clear)
            } else {
                ArViewControlBar(viewModel: viewModel)
            }
        }
    }
}

struct NonARViewContainer: UIViewRepresentable {
    @Bindable var viewModel: CodeEditorViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        let world = viewModel.world
        
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
        let cameraAnchor = AnchorEntity()
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        // Initial Camera Position (behind world)
        let cameraDistance: Float = world.tileWidth * Float(world.getLength()) + 0.1
        cameraAnchor.position = [0, 0.2, cameraDistance]
        cameraAnchor.look(at: [0, 0, 0], from: cameraAnchor.position, relativeTo: nil)
        

        // Store camera anchor & world anchor in Coordinator
        context.coordinator.cameraAnchor = cameraAnchor
        context.coordinator.worldAnchor = worldAnchor
        context.coordinator.cameraDistance = cameraDistance

        // Add Pan Gesture Recognizer for Rotation
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panGesture)
        
        if let exerciseEditorViewModel = viewModel as? ExerciseEditorViewModel {
            exerciseEditorViewModel.reset()
            exerciseEditorViewModel.executeAllWithoutDispatcher()
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator {
        var cameraAnchor: AnchorEntity?
        var worldAnchor: AnchorEntity?
        var cameraDistance: Float = 1.0
        private var currentYaw: Float = 0       // Horizontal rotation (Y-axis)
        private var currentPitch: Float = 0.5  // Vertical rotation (X-axis)

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let cameraAnchor = cameraAnchor else { return }

            let translation = gesture.translation(in: gesture.view)
            let rotationSpeed: Float = 0.005    // Adjust sensitivity

            let newYaw = currentYaw - Float(translation.x) * rotationSpeed  // Rotate left/right
            let newPitch = currentPitch + Float(translation.y) * rotationSpeed  // Rotate up/down

            // Limit pitch rotation between -10° (slightly below horizon) and 60° (looking down)
            let clampedPitch = max(.pi / 18, min(.pi / 3, newPitch))

            let x = cameraDistance * cos(clampedPitch) * sin(newYaw)
            let y = cameraDistance * sin(clampedPitch)
            let z = cameraDistance * cos(clampedPitch) * cos(newYaw)

            cameraAnchor.position = [x, y, z]
            cameraAnchor.look(at: [0, 0, 0], from: cameraAnchor.position, relativeTo: nil)

            if gesture.state == .ended {
                currentYaw = newYaw
                currentPitch = clampedPitch
            }
        }
    }
    
}
