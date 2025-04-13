//
//  ExerciseSelection.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct ExerciseSelection: View {
    @Bindable var viewModel: ChallengeViewModel
    
    @ViewBuilder
    func exerciseRow(for exercise: Exercise, isPlanned: Bool = false) -> some View {
        var completedList: [(Participant, Date)] { viewModel.room?.participants
                .compactMap { participant in
                    if let completionDate = participant.completedExercises[exercise.id.uuidString] {
                        return (participant, completionDate)
                    } else {
                        return nil
                    }
                }
                .sorted(by: { $0.1 < $1.1 }) ?? []
        }
        
        let columns = [
            GridItem(.adaptive(minimum: 600, maximum: 700), spacing: 8)
        ]
        
        let amountOfCompleteShow = 5
        
        HStack(alignment: .center) {
            
            if isPlanned {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .frame(width: 10, height: 30)
            }
            
            Image("projectIcon")
                .resizable()
                .scaledToFit()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(exercise.exerciseDifficulty.colorName))
                ).padding(.leading, 15)
            
            if isPlanned {
                HStack{
                    Text("\(exercise.exerciseName)")
                    Spacer()
                }
                .lineLimit(1)
                .truncationMode(.tail)
            } else {
                VStack(alignment: .leading) {
                    HStack{
                        Text("\(exercise.exerciseName)")
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        HStack {
                            ForEach(Array(completedList.prefix(amountOfCompleteShow).enumerated()), id: \.element.0.id) { (index, element) in
                                let (participant, _) = element
                                
                                Text("\(index+1).\(participant.name)")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(index < 3 ? .blue.opacity(0.3) : .gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            
                            if completedList.count > amountOfCompleteShow {
                                Text("\(completedList.count - amountOfCompleteShow) more")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }.padding(15)
            }
        }
    }
    
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
                                    exerciseRow(for: exercise).frame(height: 70)
                                }
                            })
                        }
                        
                        if let currentExercise = viewModel.currentExercise {
                            Section(header: Text("Current Exercise"), content: {
                                exerciseRow(for: currentExercise).frame(height: 70)
                            })
                        }
                        
                        if !viewModel.plannedExerciseList.isEmpty {
                            Section(header: Text("Planned Exercises"), content: {
                                ForEach (viewModel.plannedExerciseList, id: \.id) { exercise in
                                    exerciseRow(for: exercise, isPlanned: true).frame(height: 50)
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
    let model: MockModel = MockModel()
    viewModel.pastExerciseList.append(model.exerciseTemplates[0])
    viewModel.pastExerciseList.append(model.exerciseTemplates[1])
    let participant1 = Participant(id: "1", name: "Ramona", score: 5, isActive: true, isReady: true, completedExercises: [model.exerciseTemplates[0].id.uuidString:Date()])
    let participant2 = Participant(id: "2", name: "Max", score: 5, isActive: true, isReady: true, completedExercises: [model.exerciseTemplates[0].id.uuidString:Date()])
    let participant3 = Participant(id: "3", name: "Martin", score: 5, isActive: true, isReady: true, completedExercises: [model.exerciseTemplates[0].id.uuidString:Date()])
    let participant4 = Participant(id: "4", name: "Jonas", score: 5, isActive: true, isReady: true, completedExercises: [model.exerciseTemplates[0].id.uuidString:Date()])
    let participant5 = Participant(id: "5", name: "Lukas", score: 5, isActive: true, isReady: true, completedExercises: [model.exerciseTemplates[0].id.uuidString:Date()])
    viewModel.room = Room(code: "1", isOwner: true, participants: [participant1, participant2, participant3, participant4, participant5])
    
    return ExerciseSelection(viewModel: viewModel)
}
