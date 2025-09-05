//
//  NaturalLanguageQueryView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  NaturalLanguageQueryView.swift
//  Mocha
//
//  Lets the user ask questions about their finances and get AI responses.
//

import SwiftUI

struct NaturalLanguageQueryView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var result: QueryResult?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Ask Mocha AI")
                    .font(.title2.weight(.bold))

                Text("Type a question about your money.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("e.g., How much weekly to reach $300 rent?", text: $query)
                    .textFieldStyle(LiquidGlassTextFieldStyle())

                Button {
                    Task {
                        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        isLoading = true
                        result = await viewModel.processNaturalLanguageQuery(query)
                        isLoading = false
                    }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView().progressViewStyle(.circular)
                        }
                        Image(systemName: "brain.head.profile")
                        Text("Ask AI")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .buttonStyle(.plain)
                .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)

                if let result = result {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("AI Response")
                            .font(.headline.weight(.semibold))
                        Text(result.answer)
                            .font(.body)
                        if !result.suggestedActions.isEmpty {
                            Text("Suggested Actions")
                                .font(.subheadline.weight(.medium))
                            ForEach(result.suggestedActions, id: \.self) { action in
                                Text("• \(action)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                }

                Spacer()
            }
            .padding()
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NaturalLanguageQueryView(viewModel: MochaViewModel())
}
