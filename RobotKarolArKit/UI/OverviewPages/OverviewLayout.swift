//
//  OverviewLayout.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 14.03.25.
//

import SwiftUI

struct OverviewLayout<Content: View>: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let content: () -> Content
    
    var title: String
    
    @Binding var sortingTag: SortingTags
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text(LocalizedStringKey(title)).font(.system(size: 30, weight: .semibold, design: .rounded))
                    Divider().padding(0)
                }
                HStack {
                    Spacer()
                    Picker("Sorting", selection: $sortingTag) {
                        Text("Date").tag(SortingTags.date)
                        Text("Name").tag(SortingTags.name)
                        Text("Type").tag(SortingTags.kind)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                    Spacer()
                }
                
                LazyVGrid(columns: columns, spacing: 30) {
                    content()
                }.padding()
            }.padding()
        }
    }
}

#Preview {
    @Previewable @State var kind: SortingTags = .date
    return OverviewLayout(content: {Text("Preview")}, title: "TestTitle", sortingTag: $kind)
}

enum SortingTags: String {
    case date, name, kind
}
