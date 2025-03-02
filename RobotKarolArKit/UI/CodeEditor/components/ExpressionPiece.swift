//
//  ExpressionPiece.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 28.02.25.
//

import SwiftUI

//TODO: LONG EXPRESSIONS GET SQUISHED -> FIND SOLUTION FOR BETTER REPRESENTATION
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
                    .dropDestination(for: Instruction.self) { items, _ in
                        viewModel.handleInstructionDrop(instruction: items.first ?? Step(), targetInstruction: andExpression)
                        return true
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
            .draggable(andExpression)
        } else if let orExpression = expression as? Or {
            HStack {
                ExpressionPiece(expression: orExpression.left, viewModel: viewModel)
                expressionText(expression: expression, isEmpty: false)
                    .dropDestination(for: Instruction.self) { items, _ in
                        viewModel.handleInstructionDrop(instruction: items.first ?? Step(), targetInstruction: orExpression)
                        return true
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
            .draggable(orExpression)
        } else if let notExpression = expression as? Not {
            HStack {
                expressionText(expression: expression, isEmpty: false)
                    .dropDestination(for: Instruction.self) { items, _ in
                        viewModel.handleInstructionDrop(instruction: items.first ?? Step(), targetInstruction: notExpression)
                        return true
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
                .draggable(notExpression)
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
                .dropDestination(for: Instruction.self) { items, _ in
                    viewModel.handleInstructionDrop(instruction: items.first ?? Step(), targetInstruction: emptyExpression)
                    return true
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
                .dropDestination(for: Instruction.self) { items, _ in
                    viewModel.handleInstructionDrop(instruction: items.first ?? Step(), targetInstruction: expression)
                    return true
                }
                .draggable(expression)

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
