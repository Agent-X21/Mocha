// MockTypes.swift
// Temporary type stubs to make ContentView.swift compile & preview

import Foundation
import SwiftUI
import Combine

// MARK: - CoffeeJar
struct CoffeeJar: Identifiable, Hashable {
    let id = UUID()
    var name: String = "Savings"
    var balance: Decimal = 100
    var fillPercentage: Double = 0.5
    var category: Category = .general

    struct Category: Hashable, Equatable {
        var icon: String = "cup.and.saucer.fill"
        var color: Color = .brown
        static let general = Category()

        static func == (lhs: Category, rhs: Category) -> Bool {
            lhs.icon == rhs.icon // ignore color for equality
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(icon) // only hash icon
        }
    }
    static let sample = CoffeeJar()
}

// MARK: - FinancialGoal
struct FinancialGoal: Identifiable, Hashable {
    let id = UUID()
    var name: String = "Buy Laptop"
    var targetAmount: Decimal = 500
    var currentAmount: Decimal = 250
    var isCompleted: Bool = false
    var progress: Double { min(1.0, (currentAmount as NSDecimalNumber).doubleValue / max(1, (targetAmount as NSDecimalNumber).doubleValue)) }
    var remainingAmount: Decimal { targetAmount - currentAmount }
    var category = GoalCategory()
    struct GoalCategory: Hashable, Equatable {
        var timeframe: String = "This Year"
    }
    static let sample = FinancialGoal()
}

// MARK: - SpendingInsight
struct SpendingInsight: Identifiable {
    let id = UUID()
    var message: String = "Try saving more next week!"
    var suggestedAction: String? = "Review your coffee spending."
    var type: InsightType = .savingsOpportunity
    var severity: Severity = .info
    enum InsightType: Hashable, Equatable { case overspending, savingsOpportunity, spendingPattern, goalProgress }
    enum Severity: Hashable, Equatable { case info, warning, critical }
}

// MARK: - QueryResult
struct QueryResult {
    var answer: String = "Save $20 each week to reach your goal."
    var suggestedActions: [String] = ["Track weekly income."]
}

// MochaViewModel mock disabled for live app build (see MochaViewModel.swift)
/*
// MARK: - MochaViewModel (mock)
class MochaViewModel: ObservableObject {
    // Onboarding
    @Published var showingOnboarding: Bool = false
    func completeOnboarding() { showingOnboarding = false }

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

    // Methods (no-op)
    func addIncome(amount: Decimal) {}
    func addGoal(name: String, target: Decimal) {}
    func addProgress(to goal: FinancialGoal, amount: Decimal) {}
    func transfer(from: CoffeeJar, to: CoffeeJar, amount: Decimal) {}
    func processNaturalLanguageQuery(_ query: String) async -> QueryResult { QueryResult() }
}
*/
