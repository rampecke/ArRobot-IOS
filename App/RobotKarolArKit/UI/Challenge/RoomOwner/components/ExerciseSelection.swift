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
                    HStack{
                        Text("ExerciseName")
                            .frame(width: 100)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("Difficulty")
                            .frame(width: 100)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("Status")
                            .frame(width: 100)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    Divider()
                    
                    ScrollView {
                        if !viewModel.pastExerciseList.isEmpty {
                            ForEach (viewModel.pastExerciseList, id: \.id) { exercise in
                                HStack{
                                    Text("\(exercise.exerciseName)")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("\(exercise.exerciseDifficulty)")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("Done")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                        }
                        
                        if let currentExercise = viewModel.currentExercise {
                            HStack{
                                Text("\(currentExercise.exerciseName)")
                                    .frame(width: 100)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text("\(currentExercise.exerciseDifficulty)")
                                    .frame(width: 100)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                ProgressView()
                                    .frame(width: 100)
                            }
                        }
                        
                        if !viewModel.plannedExerciseList.isEmpty {
                            ForEach (viewModel.plannedExerciseList, id: \.id) { exercise in
                                HStack{
                                    Text("\(exercise.exerciseName)")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("\(exercise.exerciseDifficulty)")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text("Planned")
                                        .frame(width: 100)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                        }
                    }.frame(minHeight: 100, idealHeight: 400)
                }
            }.frame(width: 300)
                .padding()
                .background(Color("card_background"))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("card_border"), lineWidth: 1)
                )
            
            Button(action: {
                if let exercise = viewModel.currentExercise {
                    viewModel.pastExerciseList.append(exercise)
                }
                if let exercise = viewModel.plannedExerciseList.first {
                    viewModel.sendExercise(exercise: exercise)
                    viewModel.plannedExerciseList.removeFirst()
                }
            }, label: {
                Text("Send next exercise")
            })
        }
    }
}

#Preview {
    ExerciseSelection(viewModel: ChallengeViewModel())
}
