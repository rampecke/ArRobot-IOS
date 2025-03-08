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
        VStack (spacing: 10) {
            Image("projectIcon")
                .resizable()
                .scaledToFit()
                .font(.system(size: 24, weight: .bold))
                .padding(5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("folder_color"))
                )
            
            Button(action: {self.isShowingPopover = true}) {
                Text("\(project.name) >")
                    .frame(maxWidth: .infinity)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
                }).padding(10)
                    .font(.system(size:20, design: .rounded))
                    .background(Color("card_background"))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("card_border"), lineWidth: 1)
                    )
                    .onAppear {
                        titleChangeString = project.name
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Divider()
                Group {
                    Text("Length: \(project.worldLength)")
                    Text("Width: \(project.worldWidth)")
                }.padding(.horizontal, 10)
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
            }.padding()
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
