//
//  CoffeeJar.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


import Foundation
import SwiftUI

// MARK: - CoffeeJar Model
struct CoffeeJar: Identifiable {
    let id = UUID()
    let name: String
    let category: JarCategory
    var balance: Decimal
    var goalAmount: Decimal?

    // Fill percentage for progress bars (0 to 1)
    var fillPercentage: Decimal {
        guard let goal = goalAmount, goal > 0 else { return 0.0 }
        return min(balance / goal, 1.0)
    }
}

// MARK: - JarCategory
enum JarCategory: String, CaseIterable {
    case essentials
    case savings
    case fun
    case bills
    case investments
    case emergency

    var icon: String {
        switch self {
        case .essentials:   return "cart.fill"
        case .savings:      return "banknote.fill"
        case .fun:          return "gamecontroller.fill"
        case .bills:        return "doc.text.fill"
        case .investments:  return "chart.bar.fill"
        case .emergency:    return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .essentials:   return .yellow
        case .savings:      return .green
        case .fun:          return .pink
        case .bills:        return .red
        case .investments:  return .blue
        case .emergency:    return .orange
        }
    }

    var description: String {
        switch self {
        case .essentials:   return "Necessary everyday spending."
        case .savings:      return "Money you put aside for future."
        case .fun:          return "Leisure and entertainment."
        case .bills:        return "Monthly recurring expenses."
        case .investments:  return "Funds for growth and wealth."
        case .emergency:    return "Funds for unexpected expenses."
        }
    }
}
