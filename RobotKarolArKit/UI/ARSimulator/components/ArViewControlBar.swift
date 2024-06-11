//
//  ArViewControlBar.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 12.06.24.
//

import SwiftUI

struct ArViewControlBar: View {
    @Bindable var viewModel: CodeEditorViewModel
    var body: some View {
        HStack{
            HStack {
                Button("switchAr") {
                    viewModel.switchAr()
                }
                Button("nextMove") {
                    viewModel.next()
                }
            }
            
            Spacer()
            
            HStack {
                Button("executeAll") {
                    viewModel.executeAll()
                }
                Button("faster") {
                    viewModel.executionSpeed = viewModel.executionSpeed/2
                }
                Button("slower") {
                    viewModel.executionSpeed = viewModel.executionSpeed + viewModel.executionSpeed
                }
            }
            
            Spacer()
            
            HStack {
                Button("resetCode") {
                    viewModel.resetCode()
                }
                Button("Reset") {
                    viewModel.reset()
                }
            }
        }.padding(10)
    }
}

#Preview {
    ArViewControlBar(viewModel: CodeEditorViewModel())
}
