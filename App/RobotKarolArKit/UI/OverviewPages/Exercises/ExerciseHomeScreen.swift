//
//  ExerciseHomeScreen.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.03.25.
//

import SwiftUI

struct ExerciseHomeScreen: View {
    @Environment(Model.self) var model: Model
    @State var sortingTag: SortingTags = .date
    
    func sort() {
        switch sortingTag {
        case .date: model.sortExercisesByLastUpdated()
        case .name: model.sortExercisesByName()
        case .kind: model.sortExercisesByDifficulty()
        }
    }
    
    var body: some View {
        OverviewLayout(content: {
            Group {
                NavigationLink {
                    ExerciseEditorView() //Exercise is not yet created
                } label: {
                    CreateNewButton(action: {}, lableOnly: true, lableText: "New Exercise...").frame(height: 180).padding(.horizontal, 15)
                }
                
                ForEach(model.exerciseTemplates, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseEditorView(exercise: exercise) //Open next view with existing exercise
                    } label: {
                        ExerciseElement(exercise: exercise).frame(height: 180).padding(.horizontal, 15)
                    }
                }
            }.onChange(of: sortingTag) {
                sort()
            }
        }, title: "Exercise Templates", sortingTag: $sortingTag).onAppear {
            sort()
        }.onChange(of: model.projects.count) {
            sort()
        }
    }
}

#Preview {
    ExerciseHomeScreen().environment(MockModel() as Model)
}
