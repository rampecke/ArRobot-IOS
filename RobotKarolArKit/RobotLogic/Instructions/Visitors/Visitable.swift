//
//  Visitable.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 27.03.24.
//

import Foundation

protocol Visitable {
    func accept(visitor: Visitor)
}
