//
//  CreateRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct CreateRoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                viewModel.createRoom()
            }, label: {
                Text("Create Room")
            })
        }
    }
}

#Preview {
    CreateRoomView(viewModel: ChallengeViewModel())
}
