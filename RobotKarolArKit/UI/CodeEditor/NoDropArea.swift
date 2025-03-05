//
//  NoDropArea.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 03.03.25.
//

import Foundation
import CoreTransferable

class NoDropArea: Transferable, Codable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: NoDropArea.self, contentType: .noDropArea)
    }
}
