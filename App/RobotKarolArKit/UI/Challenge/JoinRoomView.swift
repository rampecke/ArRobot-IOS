//
//  JoinRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import SwiftUI

struct JoinRoomView: View {
    @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    @State var roomExists: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
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
            }
            if viewModel.errorMessage != nil {
                Text("\(viewModel.errorMessage ?? "No error")")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(isPresented: $roomExists) {
                RoomView(viewModel: viewModel)
            }
            .onChange(of: viewModel.room) {
                if viewModel.room != nil {
                    roomExists = true
                }
            }
            .onAppear {
                roomExists = false
            }
    }
}

#Preview {
    JoinRoomView()
}
