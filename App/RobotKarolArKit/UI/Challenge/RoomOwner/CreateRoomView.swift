//
//  CreateRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct CreateRoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    CreateNewButton(action: {
                        viewModel.createRoom()
                    }, lableText: "New Room...")
                    
                    ForEach(viewModel.myFetchedRooms, id: \.id) { room in
                        Button(action: {
                            viewModel.joinRoom(roomCode: room.code)
                        }, label: {
                            VStack (spacing: 10) {
                                Text("\(room.code)")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(20)
                                    .frame(width: 180, height: 110)
                                    .foregroundColor(.primary.opacity(0.5))
                                    .background(Color("card_background"))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("card_border"), lineWidth: 1)
                                    )
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                    }
                }.padding()
            }
            
            if let message = viewModel.errorMessage {
                Text(message)
            }
        }.navigationTitle(LocalizedStringKey("Create new room"))
            .onAppear {
            viewModel.fetchOwnedRooms()
        }
    }
}

#Preview {
    CreateRoomView(viewModel: ChallengeViewModel())
}
