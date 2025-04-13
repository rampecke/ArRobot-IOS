//
//  JoinRoomView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI
import SceneKit

struct JoinRoomView: View {
    @Bindable var viewModel: ChallengeViewModel
    
    var heightUpperElement = UIScreen.main.bounds.height/2.5
    
    @ViewBuilder
    func FullWidthButton(title: String, primary: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(LocalizedStringKey(stringLiteral: title))
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(primary ? Color.gray : Color.gray.opacity(0.2))
                .foregroundColor(primary ? .contrast : .primary)
                .fontWeight(.semibold)
                .cornerRadius(12)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if viewModel.codeDetected {
                Group{
                    if let exists = viewModel.roomExists {
                        if exists {
                            SceneView(scene: SCNScene(named: "RobotVersion7.usdz"), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                                .frame(width: UIScreen.main.bounds.width, height: heightUpperElement)
                            
                            Text("Add your name")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            
                            VStack (spacing: 20){
                                TextField(
                                    "User Name",
                                    text: $viewModel.userName
                                ).textFieldStyle(.roundedBorder)
                                
                                HStack(spacing: 20) {
                                    FullWidthButton(title: "Scan different code") {
                                        viewModel.roomCode = ""
                                        viewModel.codeDetected = false
                                    }
                                    
                                    FullWidthButton(title: "Join room", primary: true) {
                                        viewModel.joinRoom()
                                    }
                                }
                            }.frame(width: 500)
                        } else {
                            VStack(spacing: 20) {
                                Text("Sorry there was no room with code: \(viewModel.roomCode)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                
                                FullWidthButton(title: "Scan different code") {
                                    viewModel.roomCode = ""
                                    viewModel.codeDetected = false
                                }
                            }.frame(width: 500)
                        }
                    } else {
                        ProgressView()
                    }
                }.onAppear {
                    viewModel.checkIfRoomExists()
                }
                .onDisappear {
                    viewModel.codeDetected = false
                    viewModel.roomCode = ""
                }
            } else {
                QRScanner(scannedCode: $viewModel.roomCode, codeDetected: $viewModel.codeDetected, size: self.heightUpperElement)
                
                Text("Scan your room code")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                VStack (spacing: 20){
                    TextField(
                        "Room Code",
                        text: $viewModel.roomCode
                    ).textFieldStyle(.roundedBorder)
                    
                    FullWidthButton(title: "Join room") {
                        viewModel.codeDetected = true
                    }
                }.frame(width: 500)
            }
        }.navigationTitle(LocalizedStringKey("Join a room"))
            .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    JoinRoomView(viewModel: ChallengeViewModel())
}
