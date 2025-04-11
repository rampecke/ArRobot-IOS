//
//  JoinRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct JoinRoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    
    var body: some View {
        VStack(alignment: .center) {
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
        }.frame(width: 300)
    }
}

#Preview {
    JoinRoomView(viewModel: ChallengeViewModel())
}
