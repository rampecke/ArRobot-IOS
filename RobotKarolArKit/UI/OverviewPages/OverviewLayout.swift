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
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text(LocalizedStringKey(title)).font(.system(size: 30, weight: .semibold, design: .rounded))
                    Divider().padding(0)
                }
                LazyVGrid(columns: columns, spacing: 30) {
                    content()
                }.padding()
            }.padding()
        }
    }
}

#Preview {
    OverviewLayout(content: {Text("Preview")}, title: "TestTitle")
}
