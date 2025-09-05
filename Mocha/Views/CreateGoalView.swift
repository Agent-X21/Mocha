//
//  CreateGoalView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  CreateGoalView.swift
//  Mocha
//
//  A modal to create a new financial goal.
//

import SwiftUI

struct CreateGoalView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add a New Goal")
                    .font(.title2.weight(.bold))

                TextField("Goal Name", text: $viewModel.newGoalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Target Amount", value: $viewModel.newGoalAmount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addGoal(name: viewModel.newGoalName, target: viewModel.newGoalAmount)
                        dismiss()
                    }
                    .bold()
                    .disabled(viewModel.newGoalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              || viewModel.newGoalAmount <= 0)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CreateGoalView(viewModel: MochaViewModel())
}
