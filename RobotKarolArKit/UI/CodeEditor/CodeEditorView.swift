//
//  CodeEditorView.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 07.06.24.
//

import SwiftUI

struct CodeEditorView: View {
    var body: some View {
        VStack {
            CodeLine(nameOfInstruction: "step")
            CodeLine(nameOfInstruction: "step")
                            .environment(\.locale, .init(identifier: "en"))
            CodeLine(nameOfInstruction: "turnRight")
            CodeLine(nameOfInstruction: "turnRight")
                            .environment(\.locale, .init(identifier: "en"))
            CodeLine(nameOfInstruction: "turnLeft")
            CodeLine(nameOfInstruction: "turnLeft")
                            .environment(\.locale, .init(identifier: "en"))
            CodeLine(nameOfInstruction: "lift")
            CodeLine(nameOfInstruction: "lift")
                            .environment(\.locale, .init(identifier: "en"))
        }
    }
}

#Preview {
    CodeEditorView()
}
