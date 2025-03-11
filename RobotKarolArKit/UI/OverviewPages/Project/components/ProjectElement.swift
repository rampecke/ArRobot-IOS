//
//  ProjectElement.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct ProjectElement: View {
    @Bindable var project: Project
    @State private var isShowingPopover = false
    @State private var titleChangeString = ""
    @Environment(Model.self) var model: Model
    
    func saveNewTitle() {
        if !titleChangeString.isEmpty {
            project.name = titleChangeString
            model.saveProject(project: project)
        }
    }
    
    var body: some View {
        FolderRepresentation(isShowingPopover: $isShowingPopover, folderName: $project.name)
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
                        titleChangeString = project.name
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Divider()
                
                Text("Worldsize: \(project.worldWidth) x \(project.worldLength)").padding(.horizontal, 10)
                
                Divider()
                
                ShareLink(
                   "Export",
                   item: project,
                   preview: SharePreview("Export \(project.name)")
               )
                
                Divider()
                
                Button(action: {
                    model.deleteProject(project: project)
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
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    LazyVGrid(columns: columns, spacing: 30) {
        ForEach(MockModel().projects, id: \.id) { project in
            ProjectElement(project: Project()).frame(width: 180, height: 140)
        }
    }.padding().environment(MockModel() as Model)
}
