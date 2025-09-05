//
//  EmptyGoalsView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  EmptyGoalsView.swift
//  Mocha
//
//  Friendly empty state encouraging users to create their first goal.
//

import SwiftUI

struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundColor(.orange.opacity(0.7))

            Text("No Goals Yet")
                .font(.title2.weight(.semibold))

            Text("Create your first financial goal to start tracking your progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        )
    }
}

// MARK: - Preview
#Preview {
    EmptyGoalsView()
}
