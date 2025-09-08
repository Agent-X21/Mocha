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
    @State private var showingTransfer = false

    var body: some View {
        if viewModel.showingOnboarding {
            OnboardingView(viewModel: viewModel)
                .preferredColorScheme(darkModeEnabled ? ColorScheme.dark : ColorScheme.light)
                .transition(AnyTransition.opacity)
        } else {}
    }
}

#Preview {
    ContentView()
}
