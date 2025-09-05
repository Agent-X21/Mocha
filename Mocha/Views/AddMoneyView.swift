//
//  AddMoneyView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  AddMoneyView.swift
//  Mocha
//
//  Lets the user add money to their total balance.
//

import SwiftUI

struct AddMoneyView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    // Local text field for user input
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add Money")
                    .font(.title2.weight(.bold))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Add Money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Decimal(string: amountText) {
                            viewModel.addIncome(amount: value)
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

#Preview {
    AddMoneyView(viewModel: MochaViewModel())
}
