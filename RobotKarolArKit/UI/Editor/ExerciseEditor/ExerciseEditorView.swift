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

    // TODO: Exchange Exercise Description editor
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
                        VStack {
                            Group {
                                TextEditor(text: $viewModel.draftExercise.exerciseDescription)
                                    .textEditorStyle(PlainTextEditorStyle())
                                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                                    .overlay(
                                        VStack {
                                            if viewModel.draftExercise.exerciseDescription.isEmpty {
                                                Text("Write down your exercise description...")
                                                    .foregroundColor(.gray)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Spacer()
                                            }
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding(10)
                                    )
                                Divider()
                            }.padding(.horizontal, 10)
                            CodeBlockView(codeBlock: viewModel.project.codeBlock, viewModel: viewModel)
                        }
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
                                
                                Stepper(value: $viewModel.draftExercise.worldWidth, in: 1...20, step: 1, label: {
                                    HStack {
                                        Text(LocalizedStringKey("Width:")).frame(width: 80, alignment: .leading)
                                        Text("\(viewModel.draftExercise.worldWidth)")
                                    }
                                }) { _ in
                                    viewModel.setNewWithInWorld()
                                }.padding(.horizontal, 10)

                                // Stepper for worldLength
                                Stepper(value: $viewModel.draftExercise.worldLength, in: 1...20, step: 1, label: {
                                    HStack {
                                        Text(LocalizedStringKey("Length:")).frame(width: 80, alignment: .leading)
                                        Text("\(viewModel.draftExercise.worldLength)")
                                    }
                                }) { _ in
                                    viewModel.setNewLengthInWorld()
                                }.padding(.horizontal, 10)
                                
                                Divider()
                                
                                HStack {
                                    Text("Difficulty:").frame(width: 80, alignment: .leading)
                                    
                                    Picker("Difficulty", selection: $viewModel.draftExercise.exerciseDifficulty) {
                                        Text("Easy").tag(ExerciseDifficulty.easy)
                                        Text("Medium").tag(ExerciseDifficulty.medium)
                                        Text("Hard").tag(ExerciseDifficulty.hard)
                                    }
                                    .pickerStyle(.segmented)
                                    .colorMultiply(viewModel.draftExercise.exerciseDifficulty == .easy ? .green : (viewModel.draftExercise.exerciseDifficulty == .medium ? .yellow : .red))
                                }.padding(.horizontal, 10)
                            }.foregroundColor(.primary).padding()
                        }
                }
            }
            
            // Save Button (Right Side)
           ToolbarItem(placement: .navigationBarTrailing) {
               Button("Save") {
                   if viewModel.executionVisitor.finishedExecution {
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
    NavigationStack{
        ExerciseEditorView().environment(MockModel() as Model)
    }
}
