//
//  ChangeNameTextFieldStyle.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 11.03.25.
//

import Foundation
import SwiftUI

struct ChangeNameTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .font(.system(size: 20, design: .rounded))
            .background(Color("card_background"))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("card_border"), lineWidth: 1)
            )
    }
}
