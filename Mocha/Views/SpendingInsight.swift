//
//  SpendingInsight.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


import Foundation
import SwiftUI

// MARK: - SpendingInsight Model
struct SpendingInsight: Identifiable {
    let id = UUID()
    let message: String
    let type: InsightType
    let severity: InsightSeverity
    let suggestedAction: String?
}

// MARK: - InsightType
enum InsightType {
    case overspending
    case savingsOpportunity
    case spendingPattern
    case goalProgress
}

// MARK: - InsightSeverity
enum InsightSeverity {
    case info
    case warning
    case critical
}

// MARK: - Example Data
extension SpendingInsight {
    static let sampleInsights: [SpendingInsight] = [
        SpendingInsight(
            message: "You are spending too much on coffee this week.",
            type: .overspending,
            severity: .warning,
            suggestedAction: "Consider reducing your daily coffee purchase."
        ),
        SpendingInsight(
            message: "You have a savings opportunity.",
            type: .savingsOpportunity,
            severity: .info,
            suggestedAction: "Move $50 to your savings jar."
        ),
        SpendingInsight(
            message: "Your spending pattern shows frequent small purchases.",
            type: .spendingPattern,
            severity: .info,
            suggestedAction: nil
        ),
        SpendingInsight(
            message: "You are close to reaching a goal.",
            type: .goalProgress,
            severity: .info,
            suggestedAction: "Add $20 more to complete your goal."
        )
    ]
}
