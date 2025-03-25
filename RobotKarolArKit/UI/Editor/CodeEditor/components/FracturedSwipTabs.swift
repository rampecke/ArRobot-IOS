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
    
    @State var statementChunkIndex: Int = 0
    @State var controllFlowChunkIndex: Int = 0
    @State var expressionChunkIndex: Int = 0
    
    
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
            VStack(spacing: 0) {
                TabView(selection: $statementChunkIndex) {
                    ForEach(Array($allStatementsFractured.enumerated()), id: \.offset) { index, $chunks in
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
                        }.tag(index)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).frame(height:90)
                
                HStack(spacing: 15) { //Needs less space then the default one from PageTabViewStyle
                    ForEach(0..<allStatementsFractured.count, id: \.self) { index in
                        Capsule()
                            .fill(index == statementChunkIndex ? Color("onContrast_color").opacity(0.6) : Color("onContrast_color").opacity(0.3))
                            .frame(width: index == statementChunkIndex ? 15 : 7, height: 7)
                            .animation(.easeInOut(duration: 0.5), value: statementChunkIndex)
                    }
                }.padding(5).padding(.bottom, 5)
            }
        case 1:
            VStack(spacing: 0) {
                TabView(selection: $controllFlowChunkIndex) {
                    ForEach(Array($allConstrollFlowFractured.enumerated()), id: \.offset) { index, $chunks in
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
                        }.tag(index)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).frame(height:90)
                
                HStack(spacing: 15) {
                    ForEach(0..<allConstrollFlowFractured.count, id: \.self) { index in
                        Capsule()
                            .fill(index == controllFlowChunkIndex ? Color("onContrast_color").opacity(0.6) : Color("onContrast_color").opacity(0.3))
                            .frame(width: index == controllFlowChunkIndex ? 15 : 7, height: 7)
                            .animation(.easeInOut(duration: 0.5), value: controllFlowChunkIndex)
                    }
                }.padding(5).padding(.bottom, 5)
            }
        case 2:
            VStack(spacing: 0){
                TabView(selection: $expressionChunkIndex) {
                    ForEach(Array($allExpressionsFractured.enumerated()), id: \.offset) { index, $chunks in
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
                        }.tag(index)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).frame(height:90)
                
                HStack(spacing: 15) {
                    ForEach(0..<allExpressionsFractured.count, id: \.self) { index in
                        Capsule()
                            .fill(index == expressionChunkIndex ? Color("onContrast_color").opacity(0.6) : Color("onContrast_color").opacity(0.3))
                            .frame(width: index == expressionChunkIndex ? 15 : 7, height: 7)
                            .animation(.easeInOut(duration: 0.5), value: expressionChunkIndex)
                    }
                }.padding(5).padding(.bottom, 5)
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CodeEditorViewModel = CodeEditorViewModel()
    
    VStack{
        FracturedSwipTabs(selectionValue: .constant(0), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel)
        
        FracturedSwipTabs(selectionValue: .constant(1), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel)
        
        FracturedSwipTabs(selectionValue: .constant(2), allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel)
    }.padding(.horizontal, 10)
}
