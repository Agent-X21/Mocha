//
//  FinancialGoal.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


import Foundation
import SwiftUI

// MARK: - FinancialGoal Model
class FinancialGoal: Identifiable, ObservableObject {
    let id = UUID()
    let name: String
    let targetAmount: Double
    let category: GoalCategory
    @Published var currentAmount: Double = 0.0
    @Published var isCompleted: Bool = false

    init(name: String, targetAmount: Double, category: GoalCategory) {
        self.name = name
        self.targetAmount = targetAmount
        self.category = category
    }

    // Progress from 0.0 to 1.0
    var progress: Double {
        min(currentAmount / targetAmount, 1.0)
    }

    // Remaining amount to reach goal
    var remainingAmount: Double {
        max(targetAmount - currentAmount, 0.0)
    }

    // Update amount and check if goal is completed
    func addProgress(amount: Double) {
        currentAmount += amount
        if currentAmount >= targetAmount {
            currentAmount = targetAmount
            isCompleted = true
        }
    }
}

// MARK: - GoalCategory
enum GoalCategory: String, CaseIterable {
    case shortTerm
    case mediumTerm
    case longTerm

    var timeframe: String {
        switch self {
        case .shortTerm:   return "Short Term"
        case .mediumTerm:  return "Medium Term"
        case .longTerm:    return "Long Term"
        }
    }

    var color: Color {
        switch self {
        case .shortTerm:   return .green
        case .mediumTerm:  return .orange
        case .longTerm:    return .blue
        }
    }
}
