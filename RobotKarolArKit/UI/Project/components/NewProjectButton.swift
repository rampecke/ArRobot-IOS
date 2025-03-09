//
//  NewProjectButton.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct NewProjectButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack (spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .padding(20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                Text(LocalizedStringKey("New Project..."))
                    .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NewProjectButton(action: {}).frame(width: 180, height: 140)
}
