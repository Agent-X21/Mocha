//
//  GoalsView.swift
//  Mocha
//
//  Created by Zane Duncan on 9/4/25.
//


//
//  GoalsView.swift
//  Mocha
//
//  Displays a list of financial goals or an empty state, with a + button to add a new goal.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: MochaViewModel
    @State private var showingCreateGoal = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                if viewModel.goals.isEmpty {
                    EmptyGoalsView()
                        .padding(.top, 40)
                } else {
                    ForEach(viewModel.goals) { goal in
                        GoalCard(goal: goal, viewModel: viewModel)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Goal")
                }
            }
        }
        .sheet(isPresented: $showingCreateGoal) {
            CreateGoalView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview
#Preview {
    GoalsView(viewModel: MochaViewModel())
}
