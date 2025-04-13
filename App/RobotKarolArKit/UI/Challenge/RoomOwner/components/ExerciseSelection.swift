//
//  ExerciseSelection.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct ExerciseSelection: View {
    @Bindable var viewModel: ChallengeViewModel
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.pastExerciseList.isEmpty && viewModel.currentExercise == nil && viewModel.plannedExerciseList.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Exercise Template selected yet!", systemImage: "list.clipboard")
                    }, description: {
                        Text("Please add a exercise to distribute")
                    }).frame(minHeight: 100, idealHeight: 400)
                } else { 
                    List() {
                        if !viewModel.pastExerciseList.isEmpty {
                            Section(header: Text("Past Exercises"), content: {
                                ForEach (viewModel.pastExerciseList, id: \.id) { exercise in
                                    HStack{
                                        Text("\(exercise.exerciseName)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Spacer()
                                        Text("\(exercise.exerciseDifficulty)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                }
                            })
                        }
                        
                        if let currentExercise = viewModel.currentExercise {
                            Section(header: Text("Current Exercise"), content: {
                                VStack {
                                    HStack{
                                        Text("\(currentExercise.exerciseName)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Spacer()
                                        Text("\(currentExercise.exerciseDifficulty)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    
                                    ControllbarButton(title: "Finish exercise", icon: "flag", action: {
                                        viewModel.stopCurrentExercise()
                                    }, notInArView: true).frame(height: 30)
                                }
                            })
                        }
                        
                        if !viewModel.plannedExerciseList.isEmpty {
                            Section(header: Text("Planned Exercises"), content: {
                                ForEach (viewModel.plannedExerciseList, id: \.id) { exercise in
                                    HStack{
                                        Text("\(exercise.exerciseName)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Spacer()
                                        Text("\(exercise.exerciseDifficulty)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                }.onMove { indices, newOffset in
                                    viewModel.plannedExerciseList.move(fromOffsets: indices, toOffset: newOffset)
                                }
                                .onDelete { indexSet in
                                    viewModel.plannedExerciseList.remove(atOffsets: indexSet)
                                }
                            })
                        }
                    }.listStyle(.plain)
                }
            }
            .padding()
            .background(.contrast)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                .stroke(Color("card_border"), lineWidth: 1)
            )
        }
    }
}

#Preview {
    @Previewable @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    var model: MockModel = MockModel()
    viewModel.pastExerciseList.append(model.exerciseTemplates[0])
    
    return ExerciseSelection(viewModel: viewModel)
}
