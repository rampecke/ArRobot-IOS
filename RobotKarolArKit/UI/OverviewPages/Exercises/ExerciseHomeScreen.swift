//
//  ExerciseHomeScreen.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.03.25.
//

import SwiftUI

struct ExerciseHomeScreen: View {
    @Environment(Model.self) var model: Model
    
    var body: some View {
        OverviewLayout(content: {
            Group {
                NavigationLink {
                    ExerciseEditorView() //Exercise is not jet created
                } label: {
                    CreateNewButton(action: {}, lableOnly: true, lableText: "New Exercise...").frame(height: 140).padding(.horizontal, 15)
                }
                
                ForEach(model.exerciseTemplates, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseEditorView(exercise: exercise) //Open next view with existing exercise
                    } label: {
                        ExerciseElement(exercise: exercise).frame(height: 140).padding(.horizontal, 15)
                    }
                }
            }
        }, title: "Exercise Templates")
    }
}

#Preview {
    ExerciseHomeScreen().environment(MockModel() as Model)
}
