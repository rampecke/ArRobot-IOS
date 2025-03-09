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
    var id: UUID
    var type: String = "statement"
    
    init(id: UUID = UUID()) {
        self.id = id
    }

    func accept(visitor: Visitor) {
        // Base method (subclasses override this)
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Statement.self, contentType: .statement)
    }
    
    func asStatementDTO() -> StatementDTO{
        return StatementDTO(id: id, type: type)
    }
}
