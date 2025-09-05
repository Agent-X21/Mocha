//
//  Onboarding.swift
//  Mocha
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: MochaViewModel
    @State private var currentStep = 0
    @State private var firstName = ""
    @State private var financialGoal = ""
    @State private var features: String = ""

    private let steps = ["Welcome", "User Info", "Goal", "Features", "Ready"]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                    .progressViewStyle(.linear)
                    .tint(.blue)
                    .padding(.horizontal, 40)

                VStack(spacing: 20) {
                    switch currentStep {
                    case 0:
                        VStack(spacing: 14) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.brown)
                            Text("Welcome to Mocha")
                                .font(.largeTitle.weight(.bold))
                                .multilineTextAlignment(.center)
                            Text("We help you save money with fun coffee jars.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    case 1:
                        VStack(spacing: 14) {
                            Text("Your Name")
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    case 2:
                        VStack(spacing: 14) {
                            Text("Financial Goal")
                            TextField("Goal (e.g., Save $1000)", text: $financialGoal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    case 3:
                        VStack(spacing: 14) {
                            Text("Features & How to Use")
                            TextEditor(text: $features)
                                .frame(height: 150)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        }
                    default:
                        VStack(spacing: 14) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                            Text("You're Ready!")
                                .font(.title.weight(.bold))
                            Text("Let's start managing your money with style.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button("Back") { withAnimation(.spring()) { currentStep -= 1 } }
                            .buttonStyle(.bordered)
                    }
                    Button(currentStep == steps.count - 1 ? "Get Started" : "Next") {
                        if currentStep == steps.count - 1 {
                            viewModel.completeOnboarding()
                        } else {
                            withAnimation(.spring()) { currentStep += 1 }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canProceed)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 1: return !firstName.isEmpty
        case 2: return !financialGoal.isEmpty
        default: return true
        }
    }
}
