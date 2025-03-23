//
//  ArPlacementMenu.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 23.03.25.
//

import SwiftUI

struct ArPlacementMenu: View {
    @Binding var wasPlaced: Bool
    @Bindable var viewModel: CodeEditorViewModel
    
    var buttonHeight: CGFloat? = 30
    
    var body: some View {
        VStack {
            Text("Move your device to find a surface")
                .font(.headline)
                .padding(20)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                
                ControllbarButton(title: "Place board", icon: nil, action: {
                    wasPlaced = true
                }).frame(height: buttonHeight)
                
                ControllbarButton(title: "Use simulator", icon: nil, action: {
                    viewModel.arType = .NonAR
                }).frame(height: buttonHeight)
            }
        }.padding()
        .background(.clear)
    }
}

#Preview {
    
    ArPlacementMenu(wasPlaced: .constant(false), viewModel: CodeEditorViewModel())
}
