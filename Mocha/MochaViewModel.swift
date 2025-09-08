//
//  MochaViewModel.swift
//  Mocha
//

import SwiftUI
import Combine

// 🧠 The app’s brain
class MochaViewModel: ObservableObject {
    // Onboarding
    @Published var showingOnboarding: Bool = false

    // Jars
    @Published var jars: [CoffeeJar] = []

    // Goals
    @Published var goals: [FinancialGoal] = []

    // Transfer
    @Published var transferSourceJar: CoffeeJar?
    @Published var transferDestinationJar: CoffeeJar?
    @Published var showingTransfer: Bool = false

    // Add goal
    @Published var showingAddGoal: Bool = false
    @Published var newGoalName: String = ""
    @Published var newGoalAmount: Decimal = 0

    // Insights
    @Published var insights: [SpendingInsight] = []

    // MARK: - Functions
    func completeOnboarding() {
        showingOnboarding = false
    }

    func addIncome(amount: Decimal) {
        // Simple demo: put in first jar or create default jar
        if jars.isEmpty {
            let defaultJar = CoffeeJar(name: "Main Jar", category: .savings, balance: amount)
            jars.append(defaultJar)
        } else {
            jars[0].balance += amount
        }
        updateInsights()
    }

    func addGoal(name: String, target: Decimal) {
        let goal = FinancialGoal(name: name, targetAmount: target, category: .shortTerm)
        goals.append(goal)
    }

    func addProgress(to goal: FinancialGoal, amount: Decimal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].currentAmount += amount
            updateInsights()
        }
    }

    func transfer(from: CoffeeJar, to: CoffeeJar, amount: Decimal) {
        guard from.balance >= amount else { return }
        if let fromIndex = jars.firstIndex(where: { $0.id == from.id }),
           let toIndex = jars.firstIndex(where: { $0.id == to.id }) {
            jars[fromIndex].balance -= amount
            jars[toIndex].balance += amount
        }
    }

    func processNaturalLanguageQuery(_ query: String) async -> QueryResult {
        // Dummy result
        return QueryResult(answer: "AI says: You’re doing great!", suggestedActions: ["Check jars", "Add new goal"])
    }

    private func updateInsights() {
        // Generate dummy insights
        insights = jars.map { jar in
            SpendingInsight(message: "Consider adding more to \(jar.name)", type: .savingsOpportunity, severity: .info, suggestedAction: "Add money to \(jar.name)")
        }
    }

    var totalBalance: Decimal {
        jars.reduce(0) { $0 + $1.balance }
    }
}

