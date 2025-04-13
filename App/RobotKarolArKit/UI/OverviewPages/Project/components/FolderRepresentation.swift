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
    var date: Date?
    var withOutArrow: Bool = false
    
    var body: some View {
        VStack (spacing: 10) {
            Image("projectIcon")
                .resizable()
                .scaledToFit()
                .font(.system(size: 24, weight: .bold))
                .padding(5)
                .frame(width: 180, height: 110)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(colorString))
                )
            
            Button(action: {self.isShowingPopover = true}) {
                VStack {
                    HStack {
                        Text("\(folderName)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(withOutArrow ? .primary : .blue)
                        if !withOutArrow {
                            Text(">")
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }.frame(maxWidth: .infinity)
                    
                    if let date = date {
                        Text(date.formatted(date: .numeric, time: .shortened)).foregroundColor(.gray).font(.system(size: 10, weight: .light))
                    }
                }.frame(maxWidth: .infinity)
            }.padding(.horizontal, 5)
            .disabled(withOutArrow)
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HStack {
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color").frame(width: 180, height: 180)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color_hard", date: Date()).frame(width: 180, height: 180)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled"), colorString: "folder_color_medium").frame(width: 180, height: 180)
        FolderRepresentation(isShowingPopover: .constant(false), folderName: .constant("Untitled, but very long name"), colorString: "folder_color_easy").frame(width: 180, height: 180)
    }
}
