//
//  TransferView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  TransferView.swift
//  Mocha
//
//  Moves money from one jar to another.
//

import SwiftUI

struct TransferView: View {
    let sourceJar: CoffeeJar?
    let destinationJar: CoffeeJar?
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Transfer Money")
                    .font(.title2.weight(.bold))

                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(sourceJar?.name ?? "Choose Source")
                            .font(.body.weight(.medium))
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(destinationJar?.name ?? "Choose Destination")
                            .font(.body.weight(.medium))
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Transfer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Move") {
                        guard
                            let from = sourceJar,
                            let to = destinationJar,
                            let value = Decimal(string: amountText)
                        else { return }
                        viewModel.transfer(from: from, to: to, amount: value)
                        dismiss()
                    }
                    .bold()
                    .disabled(sourceJar == nil || destinationJar == nil || Decimal(string: amountText) == nil)
                }
            }
        }
    }
}

#Preview {
    TransferView(sourceJar: nil, destinationJar: nil, viewModel: MochaViewModel())
}
