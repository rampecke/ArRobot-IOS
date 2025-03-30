//
//  RoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 30.03.25.
//

import SwiftUI

struct RoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group{
            if viewModel.room != nil {
                Text("Room was created: \(viewModel.room?.code ?? "0") and has \(viewModel.room?.participants.count ?? 0)")
                if let participants = viewModel.room?.participants {
                    ForEach(participants, id: \.id) { participant in
                        Text("Participant: \(participant.name) has Score: \(participant.score)")
                    }
                }
            }
        }.onDisappear {
            viewModel.disconnectWebSocket()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.disconnectWebSocket()
                dismiss()
            }
        }
    }
}

#Preview {
    RoomView(viewModel: ChallengeViewModel())
}
