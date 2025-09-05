//
//  SettingsView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  SettingsView.swift
//  Mocha
//
//  Switches for dark mode, sound, haptics, and smart insights.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: MochaViewModel

    @Binding var darkModeEnabled: Bool
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool

    @State private var showingQuerySheet = false

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            Section("Feedback") {
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Haptics", isOn: $hapticsEnabled)
            }
            if !viewModel.insights.isEmpty {
                Section("Smart Insights") {
                    ForEach(viewModel.insights) { insight in
                        InsightCard(insight: insight)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingQuerySheet = true
                } label: {
                    Image(systemName: "brain.head.profile")
                }
                .accessibilityLabel("Ask AI")
            }
        }
        .sheet(isPresented: $showingQuerySheet) {
            NaturalLanguageQueryView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(
        viewModel: MochaViewModel(),
        darkModeEnabled: .constant(true),
        soundEnabled: .constant(true),
        hapticsEnabled: .constant(true)
    )
}
