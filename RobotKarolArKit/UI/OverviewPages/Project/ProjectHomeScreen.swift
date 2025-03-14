//
//  ProjectHomeScreen.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct ProjectHomeScreen: View {
    @Environment(Model.self) var model: Model
    @State var sortingTag: SortingTags = .date
    
    func sort() {
        switch sortingTag {
        case .date: model.sortProjectsByLastUpdated()
        case .name: model.sortProjectsByName()
        case .kind: model.sortProjectsByExerciseDifficulty()
        }
    }
    
    var body: some View {
        OverviewLayout(content: {
            Group {
                CreateNewButton(action: {model.addNewProject()}).frame(height: 180)
                
                ForEach(model.projects, id: \.id) { project in
                    NavigationLink {
                        CodeEditorView(project: project)
                    } label: {
                        ProjectElement(project: project).frame(height: 180)
                    }
                }
            }.onChange(of: sortingTag) {
                sort()
            }
        }, title: "Projects", sortingTag: $sortingTag).onAppear {
            sort()
        }.onChange(of: model.projects.count) {
            sort()
        }
    }
}

#Preview {
    ProjectHomeScreen().environment(MockModel() as Model)
}
