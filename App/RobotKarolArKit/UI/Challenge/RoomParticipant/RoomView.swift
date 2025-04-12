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
                    Color.white.opacity(0.5) // Semi-transparent white overlay
                                .ignoresSafeArea()
                    
                    VStack {
                        if viewModel.exerciseDidLoad {
                            if !viewModel.readyForNextExercise {
                                Text("There is a new Exercise. Are you ready?")
                                
                                Button(action: {
                                    //TODO: SEND OUT MESSAGE THAT I AM READY AND WAIT FOR THE START
                                    viewModel.readyForNextExercise = true
                                    //viewModel.exerciseStarted = true
                                }) {
                                    Text("Read!")
                                }
                            } else {
                                Text("Amazing! Waiting for the rest to get ready. Exercise will start soon.")
                            }
                        } else {
                            ProgressView()
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
                    viewModel.exerciseDidLoad = true
                }
            } else {
                DispatchQueue.main.async {
                    codeEditor.viewModel.changeExercise(project: Project())
                    viewModel.exerciseDidLoad = true
                }
            }
        })
    }
}

#Preview {
    RoomView(viewModel: ChallengeViewModel())
}
