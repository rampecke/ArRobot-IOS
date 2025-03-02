//
//  Visitable.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.03.24.
//

import Foundation
import CoreTransferable

class Instruction: Identifiable, Transferable, Codable {
    var id: UUID = UUID()

    func accept(visitor: Visitor) {
        // Base method (subclasses override this)
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Instruction.self, contentType: .plainText)
    }
}

