//
//  FabButton.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  FabButton.swift
//  Mocha
//
//  A reusable floating action button with gradient styling.
//

import SwiftUI

struct FabButton: View {
    let systemImage: String
    let gradient: [Color]
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(colors: gradient,
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

// MARK: - Preview
#Preview {
    FabButton(systemImage: "plus",
              gradient: [.green, .mint],
              accessibilityLabel: "Add Money") {
        print("Fab tapped")
    }
}
