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
            Group{
                if viewModel.currentExercise != nil {
                    self.codeEditor
                } else if viewModel.room != nil {
                    Text("Room was created: \(viewModel.room?.code ?? "0") and has \(viewModel.room?.participants.count ?? 0)")
                    if let participants = viewModel.room?.participants {
                        ForEach(participants, id: \.id) { participant in
                            Text("Participant: \(participant.name) has Score: \(participant.score) and isActive: \(participant.isActive)")
                        }
                    }
                }
            }
        }, viewModel: viewModel)
        .onChange(of: viewModel.currentExercise, {
            print("Exercise changed")
            if let exercise = viewModel.currentExercise {
                codeEditor.viewModel.changeExercise(project: Project(worldWidth: exercise.worldWidth, worldLength: exercise.worldLength, name: exercise.exerciseName, exercise: exercise))
                print("Name of new Exercise: \(exercise.exerciseName)")
                
            }
        })
    }
}

#Preview {
    RoomView(viewModel: ChallengeViewModel())
}
