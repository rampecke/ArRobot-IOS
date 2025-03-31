//
//  ExerciseSelection.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct ExerciseSelection: View {
    @Bindable var viewModel: ChallengeViewModel
    @Environment(Model.self) var model: Model
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            if model.exerciseTemplates.isEmpty {
                ContentUnavailableView(label: {
                    Label("There are no exercises available!", systemImage: "list.clipboard")
                }, description: {
                    Text("Go back and add a new exercise template!")
                })
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(model.exerciseTemplates, id: \.id) { exercise in
                            FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant(exercise.exerciseName), colorString: exercise.exerciseDifficulty.colorName, date: exercise.lastEdited).onTapGesture(perform: {
                                viewModel.sendExercise(exercise: exercise)
                            })
                        }
                    }.padding()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if let exercise = viewModel.currentExercise {
                Text("Exercise received \(exercise.exerciseName)")
            }
        }
    }
}

#Preview {
    ExerciseSelection(viewModel: ChallengeViewModel()).environment(MockModel() as Model)
}
