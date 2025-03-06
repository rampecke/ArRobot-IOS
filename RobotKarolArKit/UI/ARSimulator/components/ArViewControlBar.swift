//
//  ArViewControlBar.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 12.06.24.
//

import SwiftUI

struct ArViewControlBar: View {
    @Bindable var viewModel: CodeEditorViewModel
    @State var isSpeedMenuOpen: Bool = false
    @State var menuIndex: Int = 0
    
    func getSpeedIcon(for speed: PlaySpeed) -> Image {
        switch speed {
            case .superSlow, .slow, .superFast:
                return Image(speed.iconName)
            case .normal, .fast:
                return Image(systemName: speed.iconName)
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Picker("ArPicker", selection: $viewModel.arType) {
                    ForEach(ARType.allCases , id: \.self) { type in
                        Text("\(type.displayName)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("onContrast_color"))
                    }
                }
                .pickerStyle(.segmented)
                .background(
                    Color("contrast_color").opacity(0.6)
                )
                .clipShape(
                 .rect(
                     topLeadingRadius: 10,
                     bottomLeadingRadius: 10,
                     bottomTrailingRadius: 10,
                     topTrailingRadius: 10
                 )
                )
                .onChange(of: viewModel.arType) {
                    viewModel.reset()
                }.frame(width: 150)
                
                Spacer()
                
                ControllbarButton(title: "Reset game", icon: "arrow.triangle.2.circlepath.circle", action: {
                    viewModel.reset()
                })
            }.padding(10)
            
            Spacer()
            
            if let messageKey = viewModel.executionVisitor.executionMessage {
                ExecutionStatusLable(executionMessage: messageKey, lableType: .failed)
            } else if viewModel.executionVisitor.finishedExecution {
                ExecutionStatusLable(executionMessage: nil, lableType: .sucessfull)
            }
            
            Spacer()
            
            HStack{
                Menu {
                    ForEach(PlaySpeed.allCases, id: \.self) { speed in
                        Button( action: {
                            viewModel.executionSpeed = speed
                        }) {
                            HStack {
                                getSpeedIcon(for: speed)
                                Text(speed.displayName)
                            }
                        }
                    }
                } label: {
                    ControllbarButton(title: "Speed", icon: "timer", action: {})
                }
                
                Spacer()
                
                HStack {
                    ControllbarButton(title: "Next step", icon: "forward.frame.fill", action: {
                        viewModel.next()
                    })
                    
                    ControllbarButton(title: "Execute all", icon: "arrow.triangle.2.circlepath.circle", action: {
                        viewModel.executeAll()
                    })
                }
            }.padding(10)
        }.padding()
            .background(.clear)
    }
}

#Preview {
    ZStack {
        ArViewControlBar(viewModel: CodeEditorViewModel())
    }.background(.primary)
}
