//
//  ProjectHomeScreen.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct ProjectHomeScreen: View {
    @Environment(Model.self) var model: Model
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    NewProjectButton(action: {model.addNewProject()}).frame(height: 140).padding(.horizontal, 15)
                    
                    ForEach(model.projects, id: \.id) { project in
                        NavigationLink {
                            CodeEditorView(project: project)
                        } label: {
                            ProjectElement(project: project).frame(height: 140).padding(.horizontal, 15)
                        }
                    }
                    
                    
                    NavigationLink {
                        ExerciseEditorView()
                    } label: {
                        Text("To ExerciseEditor")
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    ProjectHomeScreen().environment(MockModel() as Model)
}
