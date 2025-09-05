//
//  GoalCard.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  GoalCard.swift
//  Mocha
//
//  Displays a single financial goal with a progress ring and some details.
//

import SwiftUI

struct GoalCard: View {
    let goal: FinancialGoal
    @ObservedObject var viewModel: MochaViewModel

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.headline.weight(.semibold))

                    Text(goal.category.timeframe)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }

            // Circular progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: goal.progress)
                    .stroke(
                        LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: goal.currentAmount)

                VStack {
                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption.weight(.bold))
                    Text(goal.currentAmount, format: .currency(code: "USD"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Text("\(goal.remainingAmount, format: .currency(code: "USD")) remaining")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        )
    }
}

// MARK: - Preview
#Preview {
    GoalCard(goal: FinancialGoal.example, viewModel: MochaViewModel())
}
