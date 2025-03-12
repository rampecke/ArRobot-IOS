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
    var colorString: String
    
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
                        .fill(Color(colorString))
                )
            
            Button(action: {self.isShowingPopover = true}) {
                HStack {
                    Text("\(folderName)")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(">")
                        .lineLimit(1)
                        .truncationMode(.tail)
                }.frame(maxWidth: .infinity)
            }.padding(.horizontal, 5)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HStack {
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color").frame(width: 180, height: 140)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color_hard").frame(width: 180, height: 140)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color_medium").frame(width: 180, height: 140)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled, but very long name"), colorString: "folder_color_easy").frame(width: 180, height: 140)
    }
}
