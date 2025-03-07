//
//  ProjectElement.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.03.25.
//

import SwiftUI

struct ProjectElement: View {
    @Bindable var project: Project
    
    var body: some View {
        VStack (spacing: 10) {
            Image("projectIcon")
                .resizable()
                .scaledToFit()
                .font(.system(size: 24, weight: .bold))
                .padding(5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("folder_color"))
                )
            Text(project.name)
                .frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ProjectElement(project: Project()).frame(width: 180, height: 140)
}
