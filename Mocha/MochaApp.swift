//
//  MainAppView.swift
//  Mocha
//

import SwiftUI

struct MainAppView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Binding var darkModeEnabled: Bool
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool

    @State private var selectedTab = 0
    @State private var showingAddMoney = false
    @State private var showingQuerySheet = false
    @State private var showingTransfer = false

    var body: some View {
        TabView(selection: $selectedTab) {

            NavigationStack {
                DashboardView(viewModel: viewModel)
                    .navigationTitle("Dashboard")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(0)

            NavigationStack {
                JarsView(viewModel: viewModel, onTapJar: { jar in
                    viewModel.transferSourceJar = jar
                    showingTransfer = true
                })
                .navigationTitle("Jars")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Jars", systemImage: "cup.and.saucer.fill") }
            .tag(1)

            NavigationStack {
                GoalsView(viewModel: viewModel)
                    .navigationTitle("Financial Goals")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Goals", systemImage: "target") }
            .tag(2)

            NavigationStack {
                SettingsView(viewModel: viewModel,
                             darkModeEnabled: $darkModeEnabled,
                             soundEnabled: $soundEnabled,
                             hapticsEnabled: $hapticsEnabled)
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(3)
        }
        .tint(.brown)
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                FabButton(systemImage: "plus", gradient: [.green, .mint], accessibilityLabel: "Add Money") {
                    showingAddMoney = true
                }
                FabButton(systemImage: "brain.head.profile", gradient: [.blue, .cyan], accessibilityLabel: "Ask AI") {
                    showingQuerySheet = true
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .sheet(isPresented: $showingAddMoney) { AddMoneyView(viewModel: viewModel) }
        .sheet(isPresented: $viewModel.showingAddGoal) { CreateGoalView(viewModel: viewModel) }
        .sheet(isPresented: $showingQuerySheet) { NaturalLanguageQueryView(viewModel: viewModel) }
        .sheet(isPresented: $viewModel.showingTransfer) {
            TransferView(sourceJar: viewModel.transferSourceJar,
                         destinationJar: viewModel.transferDestinationJar,
                         viewModel: viewModel)
        }
        .sheet(isPresented: $showingTransfer) {
            TransferView(sourceJar: viewModel.transferSourceJar,
                         destinationJar: viewModel.transferDestinationJar,
                         viewModel: viewModel)
        }
    }
}
