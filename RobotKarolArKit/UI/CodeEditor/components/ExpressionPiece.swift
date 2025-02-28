//
//  ExpressionPiece.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import SwiftUI

struct ExpressionPiece: View {
    @Bindable var expression: Expression
    let instructionColorHelper: InstructionColorNameHelper = InstructionColorNameHelper()
    @Bindable var viewModel: CodeEditorViewModel
    
    func expressionText(expression: Expression, isEmpty: Bool) -> Text {
        Text(LocalizedStringKey(instructionColorHelper.getNameOfInstruction(instruction: expression)))
            .foregroundColor(isEmpty ? Color.white : instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: expression), .onPrimary))
            .font(.system(size: 20, weight: .semibold, design: .rounded))
    }
    
    var body: some View {
        if let andExpression = expression as? And {
            HStack {
                ExpressionPiece(expression: andExpression.left, viewModel: viewModel)
                expressionText(expression: expression, isEmpty: false)
                    .onDrop(of: [.text], isTargeted: nil) { providers in
                        viewModel.handleDrop(providers: providers, targetInstructionID: andExpression.id, codeBlock: nil)
                    }
                ExpressionPiece(expression: andExpression.right, viewModel: viewModel)
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: expression), .primary))
            .clipShape(
             .rect(
                 topLeadingRadius: 5,
                 bottomLeadingRadius: 5,
                 bottomTrailingRadius: 5,
                 topTrailingRadius: 5
             )
            )
            .onDrag({
                viewModel.dragItem(for: andExpression, suggestedName: DragItemType.expression.rawValue)
            })
        } else if let orExpression = expression as? Or {
            HStack {
                ExpressionPiece(expression: orExpression.left, viewModel: viewModel)
                expressionText(expression: expression, isEmpty: false)
                    .onDrop(of: [.text], isTargeted: nil) { providers in
                        viewModel.handleDrop(providers: providers, targetInstructionID: orExpression.id, codeBlock: nil)
                    }
                ExpressionPiece(expression: orExpression.right, viewModel: viewModel)
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: expression), .primary))
            .clipShape(
             .rect(
                 topLeadingRadius: 5,
                 bottomLeadingRadius: 5,
                 bottomTrailingRadius: 5,
                 topTrailingRadius: 5
             )
            )
            .onDrag({
                viewModel.dragItem(for: orExpression, suggestedName: DragItemType.expression.rawValue)
            })
        } else if let notExpression = expression as? Not {
            HStack {
                expressionText(expression: expression, isEmpty: false)
                    .onDrop(of: [.text], isTargeted: nil) { providers in
                        viewModel.handleDrop(providers: providers, targetInstructionID: notExpression.id, codeBlock: nil)
                    }
                ExpressionPiece(expression: notExpression.content, viewModel: viewModel)
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(instructionColorHelper.getColor(instructionColorHelper.getNameOfInstruction(instruction: expression), .primary))
                .clipShape(
                 .rect(
                     topLeadingRadius: 5,
                     bottomLeadingRadius: 5,
                     bottomTrailingRadius: 5,
                     topTrailingRadius: 5
                 )
                )
                .onDrag({
                    viewModel.dragItem(for: notExpression, suggestedName: DragItemType.expression.rawValue)
                })
        } else if let emptyExpression = expression as? EmptyExpression {
            HStack {
                expressionText(expression: emptyExpression, isEmpty: true)
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(instructionColorHelper.getColor("warning_color"))
                .clipShape(
                 .rect(
                     topLeadingRadius: 5,
                     bottomLeadingRadius: 5,
                     bottomTrailingRadius: 5,
                     topTrailingRadius: 5
                 )
                )
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    viewModel.handleDrop(providers: providers, targetInstructionID: emptyExpression.id, codeBlock: nil)
                }
            //emptyExpression is not draggable
        } else {
            HStack {
                expressionText(expression: expression, isEmpty: false) // Base case: just return text
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .background(Color("contrast_color").opacity(0.5))
                .clipShape(
                 .rect(
                     topLeadingRadius: 5,
                     bottomLeadingRadius: 5,
                     bottomTrailingRadius: 5,
                     topTrailingRadius: 5
                 )
                )
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    viewModel.handleDrop(providers: providers, targetInstructionID: expression.id, codeBlock: nil)
                }
                .onDrag({
                    viewModel.dragItem(for: expression, suggestedName: DragItemType.expression.rawValue)
                })
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    ScrollView {
        ForEach($viewModel.allExpressions, id: \.id) { $instruction in
            ExpressionPiece(expression: instruction, viewModel: viewModel)
            ExpressionPiece(expression: instruction, viewModel: viewModel)
                            .environment(\.locale, .init(identifier: "en"))
        }
    }.padding()
}
