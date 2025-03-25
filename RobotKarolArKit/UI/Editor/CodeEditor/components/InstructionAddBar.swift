//
//  InstructionAddBar.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 09.03.25.
//

import SwiftUI

struct InstructionAddBar: View {
    @Bindable var viewModel: CodeEditorViewModel
    @State var selectionValue: Int = 0
    
    var allStatementsFractured: [[Statement]] = [[Step(), Lift(), RightTurn()], [LeftTurn(), PlaceGrass(), PlaceStone()],[PlaceWater()]]
    
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
                HStack {
                    Picker("Add instruction", selection: $selectionValue) {
                        ForEach(Array(InstructionTypes.allCases.enumerated()), id: \.element) { index, instructionCategory in
                            Text(LocalizedStringKey(instructionCategory.rawValue))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("onContrast_color"))
                                .tag(index)
                        }
                    }.pickerStyle(.segmented)
                        .background(
                            Color("onContrast_color").opacity(0.3)
                        )
                        .clipShape(
                            .rect(
                                topLeadingRadius: 10,
                                bottomLeadingRadius: 10,
                                bottomTrailingRadius: 10,
                                topTrailingRadius: 10
                            )
                        )
                        .frame(width: 400)
                    
                    Spacer()
                    
                    HStack (alignment: .bottom) {
                        Spacer()
                        ControllbarButton(title: "Delete code", icon: "delete.left", action: {
                            viewModel.resetCode()
                        }, notInArView: true).frame(height: 30)
                    }
                }.padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        Color("onContrast_color").opacity(0.1)
                    )
                
                FracturedSwipTabs(selectionValue: $selectionValue, allStatements: viewModel.allStatements, allCodeBlocks: viewModel.allControllFlow, allExpression: viewModel.allExpressions, viewModel: viewModel).padding(.horizontal, 10)
            }
        }
        .background(viewModel.bottomBarTargeted ? Color("contrast_color") : .clear) //needed because of dragArea
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

enum InstructionTypes: String, CaseIterable {
    case Instruction = "Instructions"
    case ControlFlow = "ControlFlows"
    case Condition = "Conditions"
}
