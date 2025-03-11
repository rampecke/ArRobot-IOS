//
//  FolderRepresentation.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 11.03.25.
//

import SwiftUI

struct FolderRepresentation: View {
    @Binding var isShowingPopover: Bool
    @Binding var folderName: String
    
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
            
            Button(action: {self.isShowingPopover = true}) {
                Text("\(folderName) >")
                    .frame(maxWidth: .infinity)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled")).frame(width: 180, height: 140)
}
