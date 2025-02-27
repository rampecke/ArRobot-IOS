//
//  SwipeToDeleteView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import SwiftUI

struct SwipeToDeleteView<Content: View>: View {
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    let content: () -> Content
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity)
            
            content()
                .padding()
                .background(Color(.systemBackground))
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < -10 { // Swipe left
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if value.translation.width < -100 {
                                withAnimation {
                                    offset = -80
                                    isSwiped = true
                                }
                            } else {
                                withAnimation {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
        .frame(maxWidth: .infinity)
    }
}
