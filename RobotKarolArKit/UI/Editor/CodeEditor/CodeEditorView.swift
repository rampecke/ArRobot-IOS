//
//  CodeEditorView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import SwiftUI
import SplitView

struct CodeEditorView: View {
    let fraction = FractionHolder.usingUserDefaults(0.5, key: "codeEditorFraction")
    
    @State var viewModel: CodeEditorViewModel
    
    @Environment(Model.self) var model: Model
    
    init(project: Project = Project()) {
        self.viewModel = CodeEditorViewModel(project: project)
    }

    
    var body: some View {
        VStack{
            HSplit(left: {
                VStack{
                    HStack (alignment: .bottom) {
                        Spacer()
                        ControllbarButton(title: "Delete code", icon: "delete.left", action: {
                            viewModel.resetCode()
                        }, notInArView: true).frame(height: 30)
                    }.padding(.horizontal)
                    ScrollView {
                        CodeBlockView(codeBlock: viewModel.project.codeBlock, viewModel: viewModel)
                    }
                }
            }, right: {
                Group {
                    if viewModel.arType == ARType.AR {
                        ARSimulator(viewModel: viewModel)
                    } else {
                        NonArView(viewModel: viewModel, isInExerciseEditor: false)
                    }
                }
            }).fraction(fraction)
                .constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
                .styling(color: Color("card_border"))
            
            Divider()
            
            InstructionAddBar(viewModel: viewModel)
        }.onDisappear {
            viewModel.project.lastEdited = Date()
            model.saveProject(project: viewModel.project)
            viewModel.reset() //Stop runing of code
        }.toolbar(.hidden, for: .tabBar)
        .navigationTitle(self.viewModel.project.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    return NavigationStack { CodeEditorView().environment(MockModel() as Model) }
}
