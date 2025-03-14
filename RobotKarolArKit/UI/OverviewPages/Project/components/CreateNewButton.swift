//
//  NewProjectButton.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct CreateNewButton: View {
    var action: () -> Void
    
    var lableOnly: Bool = false
    var lableText: String = "New Project..."
    
    var lable: some View {
        VStack (spacing: 10) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                )
            Text(LocalizedStringKey(lableText))
                .frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var body: some View {
        if lableOnly {
            lable.foregroundColor(.blue)
        } else {
            Button(action: action) {
                lable
            }
        }
    }
}

#Preview {
    VStack{
        CreateNewButton(action: {}).frame(width: 180, height: 140)
        CreateNewButton(action: {}, lableOnly: true, lableText: "New Exercise...").frame(width: 180, height: 140)
    }
}
