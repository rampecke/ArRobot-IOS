//
//  ExeciseElement.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 11.03.25.
//

import SwiftUI

struct ExerciseElement: View {
    @Bindable var exercise: Exercise
    @State private var isShowingPopover = false
    @State private var titleChangeString = ""
    
    @Environment(Model.self) var model: Model
    
    func saveNewTitle() {
        if !titleChangeString.isEmpty {
            exercise.exerciseName = titleChangeString
            model.saveExercise(exercise: exercise)
        }
    }
    
    var body: some View {
        FolderRepresentation(isShowingPopover: $isShowingPopover, folderName: $exercise.exerciseName, colorString: exercise.exerciseDifficulty.colorName)
            .popover(
                isPresented: $isShowingPopover
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Project Name", text: $titleChangeString, onEditingChanged: { isBegin in
                        if !isBegin {
                            saveNewTitle()
                        }
                    }, onCommit: {
                        saveNewTitle()
                    }).textFieldStyle(ChangeNameTextFieldStyle())
                        .onAppear {
                            titleChangeString = exercise.exerciseName
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Divider()
                    
                    Text("Worldsize: \(exercise.worldWidth) x \(exercise.worldLength)").padding(.horizontal, 10)
                    
                    Divider()
                    
                    ShareLink(
                        "Export",
                        item: exercise,
                        preview: SharePreview("Export \(exercise.exerciseName)")
                    )
                    
                    Divider()
                    
                    Button(action: {
                        model.deleteExercise(exercise: exercise)
                    }) {
                        HStack (alignment: .center, spacing: 10) {
                            Image(systemName: "trash").foregroundColor(Color("warning_color"))
                            Text("Delete Project").foregroundColor(Color("warning_color"))
                            Spacer()
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }.foregroundColor(.primary).padding()
            }
    }
}

#Preview {
    VStack {
        ExerciseElement(exercise: Exercise()).frame(width: 180, height: 140)
        ExerciseElement(exercise: Exercise(exerciseDifficulty: .medium)).frame(width: 180, height: 140)
        ExerciseElement(exercise: Exercise(exerciseDifficulty: .hard)).frame(width: 180, height: 140)
    }.environment(MockModel() as Model)
}
