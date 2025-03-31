//
//  ParticipantList.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct ParticipantList: View {
    @Bindable var viewModel: ChallengeViewModel
    
    var body: some View {
        VStack{
            if viewModel.room?.participants.isEmpty ?? true {
                ContentUnavailableView(label: {
                    Label("No participants joined yet!", systemImage: "person.3")
                }, description: {
                    Text("Make sure you shared the correct code")
                }).frame(minHeight: 100, idealHeight: 400)
            } else {
                HStack {
                    Text("Name")
                        .font(.headline)
                        .frame(width: 100)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("Score")
                        .font(.headline)
                        .frame(width: 100)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("Connected")
                        .font(.headline)
                        .frame(width: 100)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Divider()
                
                ScrollView {
                    ForEach(viewModel.room?.participants.sorted(by: { $0.score > $1.score }) ?? [], id: \.id) { participant in
                        HStack {
                            Text(participant.name)
                                .frame(width: 100)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text("\(participant.score)")
                                .frame(width: 100)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Image(systemName: participant.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(participant.isActive ? .green : .red).frame(width: 100)
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
    }
}

#Preview {
    @Previewable @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    viewModel.room = Room(code: "1234", owner: true, participants: [Participant(id: "1", name: "Ramona", score: 5, isActive: true), Participant(id: "2", name: "Max", score: 7, isActive: false)])
    
    return ParticipantList(viewModel: viewModel)
}
