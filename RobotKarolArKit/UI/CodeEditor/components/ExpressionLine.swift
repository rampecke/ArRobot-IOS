//
//  ExpressionLine.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import SwiftUI

struct ExpressionLine: View {
    @Bindable var expression: Expression
    @Bindable var viewModel: CodeEditorViewModel
    
    var body: some View {
        HStack {
            ExpressionPiece(expression: expression, viewModel: viewModel)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(Color("contrast_color").opacity(0.5))
            .clipShape(
                .rect(
                    topLeadingRadius: 5,
                    bottomLeadingRadius: 5,
                    bottomTrailingRadius: 5,
                    topTrailingRadius: 5
                )
            )
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    ScrollView {
        ForEach($viewModel.allExpressions, id: \.id) { $instruction in
            ExpressionLine(expression: instruction, viewModel: viewModel)
            ExpressionLine(expression: instruction, viewModel: viewModel)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }.padding()
}
