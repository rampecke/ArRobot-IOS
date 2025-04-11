//
//  RoomViewLayout.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI

struct RoomViewLayout<Content: View>: View {
    let content: () -> Content
    
    @Bindable var viewModel: ChallengeViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    func endSession() {
        viewModel.leaveRoom()
        viewModel.disconnectWebSocket()
        dismiss()
    }
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDisappear {
                endSession()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .background || newPhase == .inactive {
                    endSession()
                }
            }
    }
}
