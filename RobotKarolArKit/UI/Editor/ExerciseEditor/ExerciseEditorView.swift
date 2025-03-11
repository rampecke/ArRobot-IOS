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
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: ExerciseEditorViewModel
    @Environment(Model.self) var model: Model
    @State var isShowingPopover: Bool = false
    
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
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button(action: {
                    isShowingPopover = true
                }) {
                    Text("\(viewModel.draftExercise.exerciseName) >")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .popover(
                            isPresented: $isShowingPopover
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                TextField("Exercise Name", text: $viewModel.draftExercise.exerciseName).textFieldStyle(ChangeNameTextFieldStyle())
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                                Divider()
                                
                                Text("Worldsize: \(viewModel.draftExercise.worldWidth) x \(viewModel.draftExercise.worldLength)").padding(.horizontal, 10)
                                
                                Divider()
                                
                                //TODO: ExerciseDifficulty Change
                                
                                Divider()
                            }.foregroundColor(.primary).padding()
                        }
                }
            }
            
            // Save Button (Right Side)
           ToolbarItem(placement: .navigationBarTrailing) {
               Button("Save") {
                   if !viewModel.executionVisitor.endExecution {
                       model.addNewExercise(newExercise: viewModel.getExerciseToSave())
                       dismiss()
                   } else {
                       //TODO: Show a error pop-up in view
                       print("No valid exercise code")
                   }
               }
               .font(.headline)
               .foregroundColor(.blue)
           }
        }
    }
}

#Preview {
    ExerciseEditorView().environment(MockModel() as Model)
}
