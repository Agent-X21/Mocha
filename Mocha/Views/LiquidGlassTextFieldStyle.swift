//
//  LiquidGlassTextFieldStyle.swift
//  Mocha
//
//  Created by Zane Duncan on 9/7/25.
//


//
//  LiquidGlassTextFieldStyle.swift
//  Mocha
//

import SwiftUI

/// A custom glassy text field style for the app
struct LiquidGlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}
