//
//  ProjectHomeScreen.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct ProjectHomeScreen: View {
    @Environment(Model.self) var model: Model
    
    var body: some View {
        OverviewLayout(content: {
            Group {
                CreateNewButton(action: {model.addNewProject()}).frame(height: 140).padding(.horizontal, 15)
                
                ForEach(model.projects, id: \.id) { project in
                    NavigationLink {
                        CodeEditorView(project: project)
                    } label: {
                        ProjectElement(project: project).frame(height: 140).padding(.horizontal, 15)
                    }
                }
            }
        }, title: "Projects")
    }
}

#Preview {
    ProjectHomeScreen().environment(MockModel() as Model)
}
