//
//  MochaViewModel.swift
//  Mocha
//
//  Created by Zane Duncan on 9/8/25.
//

import SwiftUI
import Combine
import Foundation

class MochaViewModel: ObservableObject {
    // Onboarding
    @Published var firstName: String = ""
    @Published var hasCompletedOnboarding: Bool = false
    @Published var showingOnboarding: Bool = false
    func completeOnboarding() {
        hasCompletedOnboarding = true
        showingOnboarding = false
    }

    // Jars
    @Published var jars: [CoffeeJar] = [CoffeeJar.sample]
    @Published var transferSourceJar: CoffeeJar? = nil
    @Published var transferDestinationJar: CoffeeJar? = nil
    @Published var showingTransfer: Bool = false

    // Goals
    @Published var goals: [FinancialGoal] = [FinancialGoal.sample]
    @Published var showingAddGoal: Bool = false
    @Published var newGoalName: String = ""
    @Published var newGoalAmount: Decimal = 100

    // Stats
    var totalBalance: Decimal { jars.reduce(0) { $0 + $1.balance } }

    // Insights
    @Published var insights: [SpendingInsight] = [SpendingInsight()]

    // Methods (stubs)
    func addIncome(amount: Decimal) {}
    func addGoal(name: String, target: Decimal) {}
    func addProgress(to goal: FinancialGoal, amount: Decimal) {}
    func transfer(from: CoffeeJar, to: CoffeeJar, amount: Decimal) {}
    func processNaturalLanguageQuery(_ query: String) async -> QueryResult { QueryResult() }
}
