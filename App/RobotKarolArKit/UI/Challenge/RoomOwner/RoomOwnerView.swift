//
//  RoomOwnerView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 31.03.25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct RoomOwnerView: View {
    @Bindable var viewModel: ChallengeViewModel
    @Environment(Model.self) var model: Model
    
    @State var infoDisplay: Int = 0
    
    // Function to generate a QR code image from a string
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    var body: some View {
        RoomViewLayout(content: {
            VStack {
                HStack {
                    VStack { //left
                        HStack {
                            Spacer()
                            Picker("Room", selection: $infoDisplay) {
                                Text("Participants").tag(0)
                                Text("Room Info").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                            Spacer()
                        }
                        
                        Group {
                            if infoDisplay == 0 {
                                ParticipantList(viewModel: viewModel)
                            } else {
                                VStack {
                                    if let roomCode = viewModel.room?.code, let qrCodeImage = generateQRCode(from: roomCode) {
                                        Image(uiImage: qrCodeImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 300, height: 300)
                                            .padding()
                                    }
        
                                    // Display the room code as text
                                    Text("RoomCode: \(viewModel.room?.code ?? "N/A")")
                                        .font(.title)
                                        .padding()
                                }
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal, 15).padding(.vertical, 5)
                    
                    VStack { //right
                        HStack {
                            ControllbarButton(title: "Send next exercise", icon: "paperplane", action: {
                                if !viewModel.plannedExerciseList.isEmpty {
                                    if let exercise = viewModel.currentExercise {
                                        viewModel.pastExerciseList.append(exercise)
                                    }
                                    if let exercise = viewModel.plannedExerciseList.first {
                                        viewModel.sendExercise(exercise: exercise)
                                        viewModel.plannedExerciseList.removeFirst()
                                    }
                                }
                            }, notInArView: true).frame(height: 30)
                            
                            Spacer()
                            
                            ControllbarButton(title: "Start next exercise", icon: "play", action: {
                                viewModel.sendStartSignal()
                            }, notInArView: true).frame(height: 30)
                        }
                        
                        ExerciseSelection(viewModel: viewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                viewModel.fetchPastExercises(exerciseTemplates: model.exerciseTemplates)
                            }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.horizontal, 15).padding(.vertical, 5)
                }
                
                ExerciseAddBar(viewModel: viewModel)
            }.background(Color("card_background")).toolbar(.hidden, for: .tabBar).ignoresSafeArea(edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
        }, viewModel: viewModel)
    }
}

#Preview {
    @Previewable @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    viewModel.room = Room(code: "12341234", isOwner: true, participants: [Participant(id: "1", name: "Ramona", score: 5, isActive: true, isReady: true), Participant(id: "2", name: "Max", score: 7, isActive: false, isReady: false)])
    
    return RoomOwnerView(viewModel: viewModel).environment(MockModel() as Model)
}
