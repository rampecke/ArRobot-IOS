//
//  InstructionAddBar.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import SwiftUI

struct InstructionAddBar: View {
    @Bindable var viewModel: CodeEditorViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        VStack {
            if viewModel.bottomBarTargeted {
                VStack(alignment: .center) {
                    Image(systemName: "trash")
                        .font(.system(size: 30))
                        .frame(width: 70, height: 70)
                        .padding(10)
                        .foregroundColor(Color("onContrast_color"))
                        .background(
                            Color("warning_color").opacity(0.3)
                        )
                        .cornerRadius(10)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach($viewModel.allStatements, id: \.id) { $instruction in
                            InstructionAddTile(instruction: instruction).frame(height: 90).onTapGesture(perform: {
                                viewModel.createNewStatement(statement: instruction)
                            }).contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                .draggable(instruction){
                                    CodeLine(instruction: instruction, CodeLineType.CodeLine)
                                        .onAppear {
                                            viewModel.dragNewStatement()
                                        }
                                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                }
                        }
                        ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
                            InstructionAddTile(instruction: instruction).frame(height: 90).onTapGesture(perform: {
                                viewModel.createNewStatement(statement: instruction)
                            }).contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                .draggable(instruction){
                                    CodeLineControllFlow(instruction: instruction, viewModel: viewModel)
                                        .onAppear {
                                            viewModel.dragNewStatement()
                                        }
                                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                }
                        }
                        ForEach($viewModel.allExpressions, id: \.id) { $instruction in
                            InstructionAddTile(instruction: instruction).frame(height: 90).onTapGesture(perform: {
                                viewModel.addNewExpressionAtNextEmptyPosition(expression: instruction)
                            }).contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                .draggable(instruction){
                                    ExpressionPiece(expression: instruction, viewModel: viewModel)
                                        .onAppear {
                                            viewModel.dragNewExpression()
                                        }
                                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                }
                        }
                    }.padding(.horizontal, 10)
                }
            }
        }.background(viewModel.bottomBarTargeted ? Color("contrast_color") : .clear) //needed because of dragArea
        .frame(height: 150)
        .if(viewModel.dragInstruction) { view in
            view.dropDestination(for: Statement.self) { items, _ in
                guard let statement = items.first else { return false }
                viewModel.deleteInstruction(deleteId: statement.id)
                return true
            } isTargeted: { inDropZone in
                viewModel.bottomBarTargeted = inDropZone
            }
        }
        .if(viewModel.dragExpression) { view in
            view.dropDestination(for: Expression.self) { items, _ in
                guard let expression = items.first else { return false }
                viewModel.deleteExpression(deleteId: expression.id)
                return true
            } isTargeted: { inDropZone in
                viewModel.bottomBarTargeted = inDropZone
            }
        }
    }
}

#Preview {
    InstructionAddBar(viewModel: CodeEditorViewModel())
}
