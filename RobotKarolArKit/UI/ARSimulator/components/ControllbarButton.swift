//
//  ControllbarButton.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 06.03.25.
//

import SwiftUI

struct ControllbarButton: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("onContrast_color"))
                    .padding(.leading, 8)
                
                Image(systemName: icon)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("onContrast_color"))
            }
            .padding(4)
            .background(
                Color("contrast_color").opacity(0.6)
            )
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling
    }
}

#Preview {
    ControllbarButton(title: "Reset code", icon: "arrow.triangle.2.circlepath.circle", action: {})
        .padding() // Adds some spacing
        .background(.primary) // Set preview background to black
}
