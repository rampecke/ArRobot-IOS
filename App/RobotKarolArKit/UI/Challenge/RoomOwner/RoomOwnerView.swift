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
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ]) {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            Picker("Room", selection: $infoDisplay) {
                                Text("Participants").tag(0)
                                Text("Room Info").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                            Spacer()
                        }.padding()
                        
                        if infoDisplay == 0 {
                            ParticipantList(viewModel: viewModel)
                        } else {
                            if let roomCode = viewModel.room?.code, let qrCodeImage = generateQRCode(from: roomCode) {
                                Image(uiImage: qrCodeImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .padding()
                            }
                            
                            // Display the room code as text
                            Text("RoomCode: \(viewModel.room?.code ?? "N/A")")
                                .font(.title)
                                .padding()
                        }
                        Spacer()
                    }
                    
                    ExerciseSelection(viewModel: viewModel)
                }
                
                Spacer()
                
                if model.exerciseTemplates.isEmpty {
                    ContentUnavailableView(label: {
                        Label("There are no exercises available!", systemImage: "list.clipboard")
                    }, description: {
                        Text("Go back and add a new exercise template!")
                    })
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(model.exerciseTemplates, id: \.id) { exercise in
                                FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant(exercise.exerciseName), colorString: exercise.exerciseDifficulty.colorName, date: exercise.lastEdited).onTapGesture(perform: {
                                    viewModel.plannedExerciseList.append(exercise)
                                })
                            }
                        }.padding()
                    }.frame(height: 180)
                }
            }
        }, viewModel: viewModel).toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    @Previewable @State var viewModel: ChallengeViewModel = ChallengeViewModel()
    viewModel.room = Room(code: "12341234", owner: true, participants: [Participant(id: "1", name: "Ramona", score: 5, isActive: true), Participant(id: "2", name: "Max", score: 7, isActive: false)])
    
    return RoomOwnerView(viewModel: viewModel).environment(MockModel() as Model)
}
