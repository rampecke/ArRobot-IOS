//
//  Statement.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 03.03.25.
//

import Foundation
import CoreTransferable

@Observable
class Statement: Instruction {
    var id: UUID = UUID()

    func accept(visitor: Visitor) {
        // Base method (subclasses override this)
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Statement.self, contentType: .statement)
    }
}
