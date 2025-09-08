//
//  DashboardView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


import SwiftUI

// MARK: - DashboardView
// This screen says hello, shows total money, quick jar stats, active goals, and smart insights.
struct DashboardView: View {
    @ObservedObject var viewModel: MochaViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // 👋 Greeting + Total Balance
                VStack(spacing: 8) {
                    Text(greeting)
                        .font(.title2.weight(.medium))
                        .foregroundColor(.secondary)
                    Text(viewModel.totalBalance, format: .currency(code: "USD"))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                }
                .padding(.top, 12)

                // 🧮 Quick Stats (one card per jar)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.jars) { jar in
                        QuickStatCard(jar: jar)
                    }
                }

                // 🎯 Active Goals
                if viewModel.goals.contains(where: { !$0.isCompleted }) {
                    ActiveGoalsSection(viewModel: viewModel)
                }

                // 💡 Smart Insights
                if !viewModel.insights.isEmpty {
                    RecentInsightsSection(insights: viewModel.insights)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    // ⏰ Simple greeting based on the hour
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
}

// MARK: - QuickStatCard
struct QuickStatCard: View {
    let jar: CoffeeJar

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: jar.category.icon)
                    .foregroundColor(jar.category.color)
                Spacer()
                Text(jar.name)
                    .font(.caption.weight(.medium))
            }

            Text(jar.balance, format: .currency(code: "USD"))
                .font(.title2.weight(.bold))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    let width = max(8, CGFloat(truncating: jar.fillPercentage as NSNumber) * geo.size.width)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [jar.category.color, jar.category.color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width, height: 8)
                        .animation(.easeInOut(duration: 0.6), value: jar.balance)
                }
            }
            .frame(height: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - ActiveGoalsSection
struct ActiveGoalsSection: View {
    @ObservedObject var viewModel: MochaViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Goals")
                .font(.title2.weight(.bold))

            ForEach(viewModel.goals.filter { !$0.isCompleted }) { goal in
                GoalProgressCard(goal: goal, viewModel: viewModel)
            }
        }
    }
}

// MARK: - GoalProgressCard
struct GoalProgressCard: View {
    let goal: FinancialGoal
    @ObservedObject var viewModel: MochaViewModel
    @State private var showingAddProgress = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(goal.name)
                    .font(.headline.weight(.semibold))

                Text("\(goal.currentAmount, format: .currency(code: "USD")) of \(goal.targetAmount, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)

                    let width: CGFloat = max(6, CGFloat(truncating: goal.progress as NSNumber) * 200)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                        .frame(width: width, height: 6)
                        .animation(.easeInOut(duration: 0.6), value: goal.currentAmount)
                }
            }

            Spacer()

            Button {
                showingAddProgress = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("Add Progress")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .sheet(isPresented: $showingAddProgress) {
            AddProgressView(goal: goal, viewModel: viewModel)
        }
    }
}

// MARK: - RecentInsightsSection
struct RecentInsightsSection: View {
    let insights: [SpendingInsight]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Smart Insights")
                .font(.title2.weight(.bold))
            ForEach(insights.prefix(3)) { insight in
                InsightCard(insight: insight)
            }
        }
    }
}

struct InsightCard: View {
    let insight: SpendingInsight

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForInsight)
                .font(.title2)
                .foregroundColor(colorForInsight)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(insight.message)
                    .font(.body.weight(.medium))

                if let action = insight.suggestedAction {
                    Text(action)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    private var iconForInsight: String {
        switch insight.type {
        case .overspending:        return "exclamationmark.triangle.fill"
        case .savingsOpportunity:  return "lightbulb.fill"
        case .spendingPattern:     return "chart.line.uptrend.xyaxis"
        case .goalProgress:        return "target"
        }
    }

    private var colorForInsight: Color {
        switch insight.severity {
        case .info:     return .blue
        case .warning:  return .orange
        case .critical: return .red
        }
    }
}

