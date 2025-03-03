//
//  Visitable.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.03.24.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

//Replaced Protocoll with normal class so it can work with Drag and Drop
protocol Instruction: Identifiable, Transferable, Codable {
    var id: UUID {get}
    
    func accept(visitor: Visitor)
}

extension UTType {
    static var statement = UTType(exportedAs: "com.ramonaeckert.RobotKarolArKit.statement")
    static var expression = UTType(exportedAs: "com.ramonaeckert.RobotKarolArKit.expression")
    static var noDropArea = UTType(exportedAs: "com.ramonaeckert.RobotKarolArKit.noDropArea")
}

