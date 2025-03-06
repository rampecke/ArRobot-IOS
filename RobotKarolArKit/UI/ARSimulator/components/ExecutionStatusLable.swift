//
//  ExecutionStatusLable.swift
//  RobotKarolArKit
//
//  Created by Ramona Eckert on 06.03.25.
//

import SwiftUI

struct ExecutionStatusLable: View {
    let executionMessage: String?
    var lableType: ExecutionStatus
        
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: getIconName()) // Dynamic icon
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(getColor())
            
            Text(LocalizedStringKey(getHeaderText()))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("onContrast_color"))
                .multilineTextAlignment(.center)
            
            if let description = executionMessage {
                Text(LocalizedStringKey(description))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("onContrast_color"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
            }
        }
        .padding(10)
        .frame(width: 220, height: 220) // Square card
        .background(Color("contrast_color").opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
    private func getIconName() -> String {
        switch lableType {
            case .failed: return "exclamationmark.triangle"
            case .sucessfull: return "checkmark.circle"
        }
    }
    
    private func getColor() -> Color {
        switch lableType {
            case .failed: return Color("warning_color")
            case .sucessfull: return Color("success_color")
        }
    }
    
    private func getHeaderText() -> String {
        switch lableType {
        case .failed: return "error_header"
        case .sucessfull: return "successful_header"
        }
    }
}

#Preview {
    VStack {
        ExecutionStatusLable(executionMessage: "step_error_message", lableType: .failed)
        ExecutionStatusLable(executionMessage: nil, lableType: .sucessfull)
    }
}

enum ExecutionStatus {
    case failed, sucessfull
}
