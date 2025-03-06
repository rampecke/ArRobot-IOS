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
    
    private func isSystemIcon() -> Bool {
        return UIImage(systemName: self.icon) != nil
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("onContrast_color"))
                    .padding(.leading, 8)
                
                if isSystemIcon() {
                    Image(systemName: icon)
                        .frame(width: 35, height: 20)
                        .foregroundColor(Color("onContrast_color"))
                } else {
                    Image(icon)
                        .frame(width: 35, height: 20)
                        .foregroundColor(Color("onContrast_color"))
                }
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
    VStack {
        ControllbarButton(title: "Reset code", icon: "arrow.triangle.2.circlepath.circle", action: {})
            .padding() // Adds some spacing
            .background(.primary) // Set preview background to black
        ControllbarButton(title: "Execute All", icon: PlaySpeed.superFast.iconName, action: {})
            .padding() // Adds some spacing
            .background(.primary) // Set preview background to black
    }
}
