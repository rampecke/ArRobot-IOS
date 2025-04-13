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
            if viewModel.codeDetected {
                //TODO: CHECK IF ROOM EXISTS
                Text("Add your name")
                TextField(
                    "User Name",
                    text: $viewModel.userName
                ).textFieldStyle(.roundedBorder)
                
                Button(action: {
                    viewModel.joinRoom()
                }, label: {
                    Text("Join Room")
                })
                Button(action: {
                    viewModel.roomCode = ""
                    viewModel.codeDetected = false
                }, label: {
                    Text("Scan diffrent code")
                })
            } else {
                QRScanner(scannedCode: $viewModel.roomCode, codeDetected: $viewModel.codeDetected)
                TextField(
                    "Room Code",
                    text: $viewModel.roomCode
                ).textFieldStyle(.roundedBorder)
                Button(action: {
                    viewModel.codeDetected = true
                }, label: {
                    Text("Try code")
                })
            }
        }.frame(width: 300).navigationTitle(LocalizedStringKey("Join a room"))
    }
}

#Preview {
    JoinRoomView(viewModel: ChallengeViewModel())
}
