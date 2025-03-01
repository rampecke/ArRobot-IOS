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

    
    var body: some View {
        VStack{
            HSplit(left: {
                ScrollView {
                    CodeBlockView(codeBlock: viewModel.codeBlock, viewModel: viewModel)
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
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach($viewModel.allStatements, id: \.id) { $instruction in
                        InstructionAddTile(instruction: instruction).frame(height: 80).onTapGesture(perform: {
                            viewModel.createNewInstruction(instruction: instruction)
                        }).onDrag({
                            viewModel.draggingInstruction = true
                            viewModel.draggingExpression = false
                            
                            return viewModel.dragItem(for: instruction, suggestedName: DragItemType.newInstruction.rawValue)
                        })
                    }
                    ForEach($viewModel.allControllFlow, id: \.id) { $instruction in
                        InstructionAddTile(instruction: instruction).frame(height: 80).onTapGesture(perform: {
                            viewModel.createNewInstruction(instruction: instruction)
                        }).onDrag({
                            viewModel.draggingInstruction = true
                            viewModel.draggingExpression = false
                            
                            return viewModel.dragItem(for: instruction, suggestedName: DragItemType.newInstruction.rawValue)
                        })
                    }
                    ForEach($viewModel.allExpressions, id: \.id) { $instruction in
                        InstructionAddTile(instruction: instruction).frame(height: 80).onTapGesture(perform: {
                            //TODO: ADD A FUNCTION/VISITOR THAT ADDS THE EXPRESSION INTO THE NEXT EMPTYEXPRESSION if there is one
                            //viewModel.createNewInstruction(instruction: instruction)
                        }).onDrag({
                            viewModel.draggingExpression = true
                            viewModel.draggingInstruction = false
                            
                            return viewModel.dragItem(for: instruction, suggestedName: DragItemType.newExpression.rawValue)
                        })
                    }
                }.padding(.horizontal, 10)
            }.frame(height: 170)
        }
    }
}

#Preview {
    return CodeEditorView()
}
