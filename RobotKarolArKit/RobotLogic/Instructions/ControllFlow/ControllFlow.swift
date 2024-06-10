//
//  ControllFlow.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 10.06.24.
//

import Foundation

protocol ControllFlow: Instruction {
    var codeBlock: [any Instruction] { get set }
}
