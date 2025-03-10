//
//  ExerciseEditorView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import SwiftUI
import SplitView

struct ExerciseEditorView: View {
    let fraction = FractionHolder.usingUserDefaults(0.5, key: "exerciseEditorFraction")
    
    @State var viewModel: ExerciseEditorViewModel
    @Environment(Model.self) var model: Model
    
    init(exercise: Exercise = Exercise()) {
        self.viewModel = ExerciseEditorViewModel(exercise: exercise)
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
                NonArView(viewModel: viewModel, isInExerciseEditor: true)
            }).fraction(fraction)
                .constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
                .styling(color: Color("card_border"))
            
            Divider()
            
            InstructionAddBar(viewModel: viewModel)
        }
        
        //TODO: SAVE THE NEW Exercise on Buttonclick -> Maybe Navbar -> Copy the project codeBlock into the exercise
    }
}

#Preview {
    ExerciseEditorView().environment(MockModel() as Model)
}
