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
                })
            } else {
                List {
                    Section(header: Text("Active Participants"), content: {
                        ForEach(viewModel.room?.participants.sorted(by: { $0.score > $1.score }).filter{$0.isActive == true} ?? [], id: \.id) { participant in
                            HStack {
                                Text(participant.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Text("\(participant.score)")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    })
                    
                    Section(header: Text("Inactive Participants"), content: {
                        ForEach(viewModel.room?.participants.sorted(by: { $0.score > $1.score }).filter {$0.isActive == false} ?? [], id: \.id) { participant in
                            HStack {
                                Text(participant.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Text("\(participant.score)")
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    })
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

#Preview {
    @Previewable @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    viewModel.room = Room(code: "1234", owner: true, participants: [Participant(id: "1", name: "Ramona", score: 5, isActive: true), Participant(id: "2", name: "Max", score: 7, isActive: false)])
    
    return ParticipantList(viewModel: viewModel)
}
