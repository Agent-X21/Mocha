//
//  ContentView.swift
//  Mocha
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MochaViewModel()
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = true
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true

    var body: some View {
        if viewModel.showingOnboarding {
            OnboardingView(viewModel: viewModel)
                .preferredColorScheme(darkModeEnabled ? .dark : .light)
                .transition(.opacity)
        } else {
            MainAppView(
                viewModel: viewModel,
                darkModeEnabled: $darkModeEnabled,
                soundEnabled: $soundEnabled,
                hapticsEnabled: $hapticsEnabled
            )
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
            .transition(.opacity)
        }
    }
}

#Preview {
    ContentView()
}
