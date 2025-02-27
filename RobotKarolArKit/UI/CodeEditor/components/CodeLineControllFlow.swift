//
//  CodeLineControllFlow.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 15.06.24.
//

import SwiftUI

struct CodeLineControllFlow: View {
    @Bindable var instruction: CodeBlock
    @Bindable var viewModel: CodeEditorViewModel
    
    func getNameOfInstruction() -> String {
        let nameVisitor = NameVisitor()
        instruction.accept(visitor: nameVisitor)
        return nameVisitor.get()
    }
    
    func getColor(_ nameOfInstruction: String, _ ending: ColorEnding) -> Color {
        if let uiColor = UIColor(named: "\(nameOfInstruction)\(ending.rawValue)") {
            return Color(uiColor)
        } else {
            if ending == .onPrimary {
                return Color.black
            } else {
                return Color.gray
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey(getNameOfInstruction()))
                    .foregroundColor(getColor(getNameOfInstruction(), .onPrimary))
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                HStack {
                    Text("Missing")
                        .foregroundColor(getColor(getNameOfInstruction(), .onPrimary))
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
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
            
            CodeBlockView(codeBlock: instruction, viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .padding(2)
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
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(getColor(getNameOfInstruction(), .primary))
            .clipShape(
                .rect(
                    topLeadingRadius: 5,
                    bottomLeadingRadius: 5,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    viewModel.allControllFlow.first?.addInstruction(instruction: Step())
    return ScrollView {
        ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
            CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }.padding()
}
