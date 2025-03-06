//
//  CodeEditorView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import SwiftUI
import SplitView

struct CodeEditorView: View {
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    let fraction = FractionHolder.usingUserDefaults(0.5, key: "myFraction")
    
    @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    @State var bottomBarTargeted = false

    
    var body: some View {
        VStack{
            HSplit(left: {
                VStack{
                    HStack (alignment: .bottom) {
                        Spacer()
                        ControllbarButton(title: "Delete code", icon: "delete.left", action: {
                            viewModel.resetCode()
                        }, notInArView: true).frame(height: 30)
                    }.padding(.horizontal)
                    ScrollView {
                        CodeBlockView(codeBlock: viewModel.codeBlock, viewModel: viewModel)
                    }
                }
            }, right: {
                Group {
                    if viewModel.arType == ARType.AR {
                        ARSimulator(viewModel: viewModel)
                    } else {
                        NonArView(viewModel: viewModel)
                    }
                }
            }).fraction(fraction)
                .constraints(minPFraction: 0.4, minSFraction: 0.4, dragToHideP: true)
                .styling(color: Color("card_border"))
            
            Divider()
            
            VStack {
                if bottomBarTargeted {
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
                                                viewModel.dragExpression = false
                                                viewModel.dragInstruction = false
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
                                                viewModel.dragExpression = false
                                                viewModel.dragInstruction = false
                                            }
                                            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                    }
                            }
                            ForEach($viewModel.allExpressions, id: \.id) { $instruction in
                                InstructionAddTile(instruction: instruction).frame(height: 90).onTapGesture(perform: {
                                    //TODO: ADD A FUNCTION/VISITOR THAT ADDS THE EXPRESSION INTO THE NEXT EMPTYEXPRESSION if there is one
                                }).contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                    .draggable(instruction){
                                        ExpressionPiece(expression: instruction, viewModel: viewModel)
                                            .onAppear {
                                                viewModel.dragExpression = false
                                                viewModel.dragInstruction = false
                                            }
                                            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 5))
                                    }
                            }
                        }.padding(.horizontal, 10)
                    }
                }
            }.background(bottomBarTargeted ? Color("contrast_color") : .clear) //needed because of dragArea
            .frame(height: 150)
            .if(viewModel.dragInstruction) { view in
                view.dropDestination(for: Statement.self) { items, _ in
                    guard let statement = items.first else { return false }
                    viewModel.deleteInstruction(deleteId: statement.id)
                    return true
                } isTargeted: { inDropZone in
                    bottomBarTargeted = inDropZone
                }
            }
            .if(viewModel.dragExpression) { view in
                view.dropDestination(for: Expression.self) { items, _ in
                    guard let expression = items.first else { return false }
                    viewModel.deleteExpression(deleteId: expression.id)
                    return true
                } isTargeted: { inDropZone in
                    bottomBarTargeted = inDropZone
                }
            }
        }
    }
}

#Preview {
    return CodeEditorView()
}
