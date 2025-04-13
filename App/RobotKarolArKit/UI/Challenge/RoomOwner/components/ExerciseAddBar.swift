//
//  ExerciseAddBar.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 12.04.25.
//

import SwiftUI

struct ExerciseAddBar: View {
    @State var sortingTag: SortingTags = .date
    @Bindable var viewModel: ChallengeViewModel
    @Environment(Model.self) var model: Model
    @State var displayedExercises: [Exercise] = []
    
    func sort() {
        switch sortingTag {
        case .date: displayedExercises = model.getExercisesSortedByLastUpdated()
        case .name: displayedExercises = model.getExerciseSortedByName()
        case .kind: displayedExercises = model.getExercisesSortedByDifficulty()
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                Picker("Sorting", selection: $sortingTag) {
                    Text("Date").tag(SortingTags.date)
                    Text("Name").tag(SortingTags.name)
                    Text("Type").tag(SortingTags.kind)
                }.pickerStyle(.segmented)
                    .colorMultiply(.gray)
                    .frame(width: 400)
                
                Spacer()
            }.padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                    Color("onContrast_color").opacity(0.1)
                )
            
            if displayedExercises.isEmpty {
                ContentUnavailableView(label: {
                    Label("There are no exercises available!", systemImage: "list.clipboard")
                }, description: {
                    Text("Go back and add a new exercise template!")
                })
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(displayedExercises, id: \.id) { exercise in
                            FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant(exercise.exerciseName), colorString: (viewModel.plannedExerciseList + viewModel.pastExerciseList).contains(where: {$0.id == exercise.id}) || viewModel.currentExercise?.id == exercise.id ? "card_border" : exercise.exerciseDifficulty.colorName, date: exercise.lastEdited, withOutArrow: true).frame(height: 170).onTapGesture(perform: {
                                var allExercises = viewModel.plannedExerciseList + viewModel.pastExerciseList
                                if let current = viewModel.currentExercise {
                                    allExercises.append(current)
                                }
                                
                                let exerciseExists = allExercises.contains(where: {$0.id == exercise.id})
                                
                                if !exerciseExists {
                                    viewModel.plannedExerciseList.append(exercise)
                                }
                            })
                        }
                    }.padding()
                }.frame(height: 170)
            }
            Spacer()
        }.frame(height: 225)
            .onChange(of: sortingTag) {
                sort()
            }
            .onAppear {
                sort()
            }
    }
}

#Preview {
    ExerciseAddBar(viewModel: ChallengeViewModel()).environment(MockModel() as Model)
}
