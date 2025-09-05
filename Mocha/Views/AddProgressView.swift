//
//  AddProgressView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


import SwiftUI

// MARK: - AddProgressView
// Allows the user to add money toward a specific financial goal.
struct AddProgressView: View {
    let goal: FinancialGoal
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    // Local text field for user input
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add Progress to")
                    .font(.callout)
                    .foregroundColor(.secondary)
                
                Text(goal.name)
                    .font(.title3.weight(.semibold))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Decimal(string: amountText) {
                            viewModel.addProgress(to: goal, amount: value)
                        }
                        dismiss()
                    }
                    .bold()
                    .disabled(Decimal(string: amountText) == nil)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    // Example usage with mock data
    AddProgressView(
        goal: FinancialGoal(name: "New Laptop", targetAmount: 1200, currentAmount: 400, category: .monthly),
        viewModel: MochaViewModel()
    )
}
