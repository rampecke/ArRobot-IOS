//
//  JoinRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 29.03.25.
//

import SwiftUI

struct ChallengeView: View {
    @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    @State var roomExists: Bool = false
    
    @State var roomCreation: Int = 1
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider().padding(.bottom, 5)
            HStack {
                Spacer()
                Picker("Room", selection: $roomCreation) {
                    Text("Create").tag(0)
                    Text("Join").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
                Spacer()
            }
                
            HStack(alignment: .center) {
                if viewModel.isLoading {
                    ProgressView()
                } else if roomCreation == 0 {
                    CreateRoomView(viewModel: viewModel)
                } else {
                    JoinRoomView(viewModel: viewModel)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(LocalizedStringKey("Challenge"))
            .navigationDestination(isPresented: $roomExists) {
                if viewModel.room?.owner ?? false {
                    RoomOwnerView(viewModel: viewModel)
                } else {
                    RoomView(viewModel: viewModel)
                }
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
    ChallengeView()
}
