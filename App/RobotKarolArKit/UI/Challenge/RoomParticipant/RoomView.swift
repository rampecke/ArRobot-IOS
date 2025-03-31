//
//  RoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 30.03.25.
//

import SwiftUI

struct RoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    @State var codeEditor: CodeEditorView = CodeEditorView(shouldSave: false)
    
    var body: some View {
        RoomViewLayout(content: {
            ZStack{
                self.codeEditor
                    .blur(radius: viewModel.readyForNextExercise && viewModel.exerciseStarted ? 0 : 15)
                
                if !(viewModel.readyForNextExercise && viewModel.exerciseStarted) {
                    Color.white.opacity(0.3) // Semi-transparent white overlay
                                .ignoresSafeArea()
                    
                    VStack {
                        Text("A new exercise is about to start are you ready?")
                        
                        Button(action: {
                            //TODO: SEND OUT MESSAGE THAT I AM READY AND WAIT FOR THE START
                            viewModel.readyForNextExercise = true
                            viewModel.exerciseStarted = true
                        }) {
                            Text("Read!")
                        }
                    }.frame(width: 300)
                        .padding()
                        .background(Color("card_background"))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("card_border"), lineWidth: 1)
                        )

                }
            }
        }, viewModel: viewModel)
        .onChange(of: viewModel.currentExercise, {
            if let exercise = viewModel.currentExercise {
                DispatchQueue.main.async {
                    codeEditor.viewModel.changeExercise(project: Project(worldWidth: exercise.worldWidth, worldLength: exercise.worldLength, name: exercise.exerciseName, exercise: exercise))
                }
            }
        })
    }
}

#Preview {
    RoomView(viewModel: ChallengeViewModel())
}
