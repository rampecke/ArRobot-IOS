//
//  Expression.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.02.25.
//

import Foundation
import CoreTransferable

@Observable
class Expression: Instruction {
    var id: UUID = UUID()

    func accept(visitor: Visitor) {
        // Base method (subclasses override this)
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Expression.self, contentType: .expression)
    }
}
