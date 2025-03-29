//
//  JoinRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import SwiftUI

struct JoinRoomView: View {
    @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                Button(action: {
                    viewModel.createRoom()
                }, label: {
                    Text("Create Room")
                })
                
                VStack {
                    TextField(
                        "Room Code",
                        text: $viewModel.roomCode
                    ).textFieldStyle(.roundedBorder)
                    
                    TextField(
                        "User Name",
                        text: $viewModel.userName
                    ).textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        viewModel.joinRoom()
                    }, label: {
                        Text("Join Room")
                    })
                }.frame(width: 150)
            }
            
            if viewModel.room != nil {
                Text("Room was created: \(viewModel.room?.code ?? "0") and has \(viewModel.room?.participants.count ?? 0)")
                if let participants = viewModel.room?.participants {
                    ForEach(participants, id: \.id) { participant in
                        Text("Participant: \(participant.name) has Score: \(participant.score)")
                    }
                }
            }
            if viewModel.errorMessage != nil {
                Text("\(viewModel.errorMessage ?? "No error")")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    JoinRoomView()
}
