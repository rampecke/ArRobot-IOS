//
//  FracturedSwipTabs.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 25.03.25.
//

import SwiftUI

struct FracturedSwipTabs: View {
    @Binding var selectionValue: Int
    @State var allStatementsFractured: [[Statement]]
    @State var allConstrollFlowFractured: [[CodeBlock]]
    @State var allExpressionsFractured: [[Expression]]
    @Bindable var viewModel: CodeEditorViewModel
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    init(selectionValue: Binding<Int>, allStatements: [Statement], allCodeBlocks: [CodeBlock], allExpression: [Expression], viewModel: CodeEditorViewModel) {
        _selectionValue = selectionValue
        
        //We need to save them in Chunks before else we get issues with a displaying delay
        let chunkSize = 3
        self.allStatementsFractured = stride(from: 0, to: allStatements.count, by: chunkSize).map {          Array(allStatements[$0..<min($0 + chunkSize, allStatements.count)])
        }
        
        self.allConstrollFlowFractured = stride(from: 0, to: allCodeBlocks.count, by: chunkSize).map {          Array(allCodeBlocks[$0..<min($0 + chunkSize, allCodeBlocks.count)])
        }
        
        self.allExpressionsFractured = stride(from: 0, to: allExpression.count, by: chunkSize).map {          Array(allExpression[$0..<min($0 + chunkSize, allExpression.count)])
        }
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch selectionValue {
        case 0:
            TabView {
                ForEach(Array($allStatementsFractured.enumerated()), id: \.offset) { index, $chunks in
                    VStack {
                        LazyVGrid(columns: columns){
                            ForEach($chunks, id: \.id) { $instruction in
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
                        }
                        Spacer()
                    }.padding(.top, 3)
                }
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
        case 1:
            TabView {
                ForEach(Array($allConstrollFlowFractured.enumerated()), id: \.offset) { index, $chunks in
                    VStack{
                        LazyVGrid(columns: columns){
                            ForEach($chunks, id: \.id) { $instruction in
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
                        }
                        Spacer()
                    }.padding(.top, 3)
                }
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
        case 2:
            TabView{
                ForEach(Array($allExpressionsFractured.enumerated()), id: \.offset) { index, $chunks in
                    VStack{
                        LazyVGrid(columns: columns){
                            ForEach($chunks, id: \.id) { $instruction in
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
                        }
                        Spacer()
                    }.padding(.top, 3)
                }
            }.tabViewStyle(.page).indexViewStyle(.page(backgroundDisplayMode: .always))
        default:
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    VStack{
        FracturedSwipTabs(selectionValue: .constant(0), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel).frame(height: 136).padding(.horizontal, 10)
        
        FracturedSwipTabs(selectionValue: .constant(1), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel).frame(height: 136).padding(.horizontal, 10)
        
        FracturedSwipTabs(selectionValue: .constant(2), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel).frame(height: 136).padding(.horizontal, 10)
    }
}
