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
    @State var hideAddBar: Bool = false
    
    @Environment(Model.self) var model: Model
    
    init(project: Project = Project()) {
        self.viewModel = CodeEditorViewModel(project: project)
    }

    
    var body: some View {
        VStack{
            HSplit(left: {
                ScrollView {
                    VStack {
                        if let exercise = viewModel.project.exercise {
                            if !exercise.exerciseDescription.isEmpty {
                                Group {
                                    Text(exercise.exerciseDescription)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                }.padding(.horizontal, 10)
                            }
                        }
                        CodeBlockView(codeBlock: viewModel.project.codeBlock, viewModel: viewModel)
                    }.onDisappear {
                        hideAddBar = true
                    }
                    .onAppear {
                        hideAddBar = false
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
                .constraints(minPFraction: 0.3, minSFraction: 0.4)
                .styling(color: Color("card_border"))
            
            if !hideAddBar {
                InstructionAddBar(viewModel: viewModel)
            }
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
