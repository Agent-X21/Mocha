//
//  MainAppView.swift
//  Mocha
//

import SwiftUI

// LazyView helper to avoid eager tab initialization
struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) { self.build = build }
    var body: Content { build() }
}

struct MainAppView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Binding var darkModeEnabled: Bool
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool
    @State private var showingTransfer = false

    var body: some View {
        TabView {
            // 🏠 Dashboard Tab
            LazyView(
                NavigationStack {
                    DashboardView(viewModel: viewModel)
                        .navigationTitle("Dashboard")
                        .navigationBarTitleDisplayMode(.large)
                        .task {
                            await viewModel.loadDashboardData() // async load, non-blocking
                        }
                }
            )
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(0)

            // ☕ Jars Tab
            LazyView(
                NavigationStack {
                    JarsView(
                        viewModel: viewModel,
                        onTapJar: { jar in
                            viewModel.transferSourceJar = jar
                            showingTransfer = false
                        }
                    )
                    .navigationTitle("Jars")
                    .navigationBarTitleDisplayMode(.large)
                }
            )
            .tabItem { Label("Jars", systemImage: "cup.and.saucer.fill") }
            .tag(1)

            // 🎯 Goals Tab
            LazyView(
                NavigationStack {
                    GoalsView(viewModel: viewModel)
                        .navigationTitle("Financial Goals")
                        .navigationBarTitleDisplayMode(.large)
                        .task {
                            await viewModel.loadGoalsData() // async load, non-blocking
                        }
                }
            )
            .tabItem { Label("Goals", systemImage: "target") }
            .tag(2)

            // ⚙️ Settings Tab
            LazyView(
                NavigationStack {
                    SettingsView(
                        viewModel: viewModel,
                        darkModeEnabled: $darkModeEnabled,
                        soundEnabled: $soundEnabled,
                        hapticsEnabled: $hapticsEnabled
                    )
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                }
            )
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(3)
        }
        .tint(.brown) // ☕ Coffee-colored tint
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

#Preview {
    MainAppView(
        viewModel: MochaViewModel(),
        darkModeEnabled: .constant(true),
        soundEnabled: .constant(true),
        hapticsEnabled: .constant(true)
    )
}
