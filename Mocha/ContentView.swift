//
//  ContentView.swift
//  Mocha
//
//  A cleaned, single-file version that:
//  - Keeps your app’s tabs and screens
//  - Removes duplicate/conflicting view definitions
//  - Fixes invalid state usage
//  - Adds simple, kid-friendly comments throughout
//

import SwiftUI
import UniformTypeIdentifiers // 📦 For drag & drop types like UTType.text

// MARK: - ContentView (the app's front door)
//
// Think of this like the front door of a house.
// We set up the app brain (view model) and hand off to the main tabs.
//
struct ContentView: View {
    // 🧠 The app's brain that stores data and logic.
    @StateObject private var viewModel = MochaViewModel()

    // 🎛 Settings saved on the device.
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = true
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true

    var body: some View {
        // 👇 If you want onboarding to show first, toggle this if/else.
        if viewModel.showingOnboarding {
            OnboardingView(viewModel: viewModel)
                .preferredColorScheme(darkModeEnabled ? .dark : .light)
                .transition(.opacity)
        } else {
            MainAppView(
                viewModel: viewModel,
                darkModeEnabled: $darkModeEnabled,
                soundEnabled: $soundEnabled,
                hapticsEnabled: $hapticsEnabled
            )
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
            .transition(.opacity)
        }
    }
}

// MARK: - MainAppView (tab bar with all main screens)
//
// This is like a bookshelf with 4 books: Dashboard, Jars, Goals, Settings.
//
struct MainAppView: View {
    @ObservedObject var viewModel: MochaViewModel

    // 🔗 These come from ContentView so settings are consistent everywhere.
    @Binding var darkModeEnabled: Bool
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool

    // 📌 Which tab is selected right now.
    @State private var selectedTab = 0

    // 🪟 These booleans show and hide popup sheets.
    @State private var showingAddMoney = false
    @State private var showingQuerySheet = false
    @State private var showingTransfer = false

    // 🧭 Modern navigation container
    var body: some View {
        TabView(selection: $selectedTab) {

            // 🏠 Dashboard Tab
            NavigationStack {
                DashboardView(viewModel: viewModel)
                    .navigationTitle("Dashboard")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            .tag(0)

            // ☕ Jars Tab
            NavigationStack {
                JarsView(
                    viewModel: viewModel,
                    onTapJar: { jar in
                        // 🪄 When a jar is tapped we can show transfer flow prefilled.
                        viewModel.transferSourceJar = jar
                        showingTransfer = true
                    }
                )
                .navigationTitle("Jars")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Jars", systemImage: "cup.and.saucer.fill") }
            .tag(1)

            // 🎯 Goals Tab
            NavigationStack {
                GoalsView(viewModel: viewModel)
                    .navigationTitle("Financial Goals")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Goals", systemImage: "target") }
            .tag(2)

            // ⚙️ Settings Tab
            NavigationStack {
                SettingsView(
                    viewModel: viewModel,
                    darkModeEnabled: $darkModeEnabled,
                    soundEnabled: $soundEnabled,
                    hapticsEnabled: $hapticsEnabled
                )
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(3)
        }
        .tint(.brown) // ☕ Coffee-colored tint for selected tab and controls.

        // ➕ Floating action buttons (like big friendly buttons in the corner).
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                // Add Money
                FabButton(
                    systemImage: "plus",
                    gradient: [.green, .mint],
                    accessibilityLabel: "Add Money"
                ) { showingAddMoney = true }

                // Ask AI
                FabButton(
                    systemImage: "brain.head.profile",
                    gradient: [.blue, .cyan],
                    accessibilityLabel: "Ask AI"
                ) { showingQuerySheet = true }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }

        // 📄 Sheets (popups)
        .sheet(isPresented: $showingAddMoney) {
            AddMoneyView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingAddGoal) {
            CreateGoalView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingQuerySheet) {
            NaturalLanguageQueryView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingTransfer) {
            // If your VM drives transfer, use that; else fall back to local flag.
            TransferView(
                sourceJar: viewModel.transferSourceJar,
                destinationJar: viewModel.transferDestinationJar,
                viewModel: viewModel
            )
        }
        .sheet(isPresented: $showingTransfer) {
            TransferView(
                sourceJar: viewModel.transferSourceJar,
                destinationJar: viewModel.transferDestinationJar,
                viewModel: viewModel
            )
        }
    }
}

// MARK: - FabButton (round floaty button)
// This is a helper so we don't repeat the same code for two circles.
//
struct FabButton: View {
    let systemImage: String
    let gradient: [Color]
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

// MARK: - DashboardView
//
// This screen says hello and shows total money and some quick cards.
//
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
                        .contentTransition(.numericText()) // smooth number change
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

    // ⏰ Simple greeting based on the hour.
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
//
// A small box that shows one jar's name, icon, amount, and a tiny progress bar.
//
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

            // 📊 Little progress bar that fills left-to-right.
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    let width = max(8, CGFloat(jar.fillPercentage) * geo.size.width)
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
//
// A header and a list of goal progress cards for goals not finished yet.
//
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
//
// Shows one goal, how much is saved, and a button to add progress.
//
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

                // 📈 Progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)

                    let width: CGFloat = max(6, CGFloat(goal.progress) * 200)
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

// MARK: - RecentInsightsSection & InsightCard
//
// This shows smart tips like “you are spending too fast”, with icons.
//
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

// MARK: - JarsView
//
// A grid of coffee jars. You can tap a jar to transfer money,
// or drag a jar onto another to start a transfer.
//
struct JarsView: View {
    @ObservedObject var viewModel: MochaViewModel

    // 🪄 When a jar is tapped, the parent can decide what to do.
    var onTapJar: (CoffeeJar) -> Void

    // For drag and drop.
    @State private var draggedJar: CoffeeJar?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                ForEach(viewModel.jars) { jar in
                    CoffeeJarCard(jar: jar) {
                        onTapJar(jar)
                    }
                    // 🖱️ Begin drag
                    .onDrag {
                        draggedJar = jar
                        return NSItemProvider(object: jar.name as NSString)
                    }
                    // 🎯 Accept drop onto another jar to trigger transfer
                    .onDrop(of: [UTType.text], delegate: DropJarDelegate(
                        target: jar,
                        draggedJar: $draggedJar,
                        viewModel: viewModel
                    ))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - CoffeeJarCard
//
// A pretty card with an icon, amount, and fill level.
//
struct CoffeeJarCard: View {
    let jar: CoffeeJar
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 14) {
                // ☕ Jar icon with a mini “liquid” fill
                ZStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 50))
                        .foregroundColor(jar.category.color)

                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [jar.category.color.opacity(0.85), jar.category.color.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 42, height: max(8, CGFloat(jar.fillPercentage) * 40))
                            .animation(.easeInOut(duration: 0.6), value: jar.balance)
                    }
                    .frame(width: 50, height: 50)
                }

                VStack(spacing: 6) {
                    Text(jar.name)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(jar.balance, format: .currency(code: "USD"))
                        .font(.title2.weight(.bold))
                        .foregroundColor(.primary)

                    Text("\(Int(jar.fillPercentage * 100))% full")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - DropJarDelegate
//
// This watches the drop. If you drop Jar A onto Jar B, we prepare a transfer.
//
struct DropJarDelegate: DropDelegate {
    let target: CoffeeJar
    @Binding var draggedJar: CoffeeJar?
    let viewModel: MochaViewModel

    func performDrop(info: DropInfo) -> Bool {
        guard let fromJar = draggedJar else { return false }
        guard fromJar.id != target.id else { return false }

        // 🧭 Set source/destination in the VM so the Transfer sheet knows what to show.
        viewModel.transferSourceJar = fromJar
        viewModel.transferDestinationJar = target
        viewModel.showingTransfer = true

        // Clear dragged reference.
        draggedJar = nil
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        // Optional: handle exit if needed.
    }
}

// MARK: - GoalsView
//
// Shows a list of goals, or an empty state, and a + button to add a goal.
//
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

// MARK: - GoalCard
//
// A round progress ring and some info about the goal.
//
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

            // 🟢 A circular progress ring
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

// MARK: - SettingsView
//
// Switches to flip on/off things like dark mode and sound.
//
struct SettingsView: View {
    @ObservedObject var viewModel: MochaViewModel

    @Binding var darkModeEnabled: Bool
    @Binding var soundEnabled: Bool
    @Binding var hapticsEnabled: Bool

    @State private var showingQuerySheet = false

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
            Section("Feedback") {
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Haptics", isOn: $hapticsEnabled)
            }
            if !viewModel.insights.isEmpty {
                Section("Smart Insights") {
                    ForEach(viewModel.insights) { insight in
                        InsightCard(insight: insight)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingQuerySheet = true
                } label: {
                    Image(systemName: "brain.head.profile")
                }
                .accessibilityLabel("Ask AI")
            }
        }
        .sheet(isPresented: $showingQuerySheet) {
            NaturalLanguageQueryView(viewModel: viewModel)
        }
    }
}

// MARK: - EmptyGoalsView
//
// A friendly empty state telling the user to make their first goal.
//
struct EmptyGoalsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundColor(.orange.opacity(0.7))

            Text("No Goals Yet")
                .font(.title2.weight(.semibold))

            Text("Create your first financial goal to start tracking your progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
        )
    }
}

// MARK: - Reusable UI Styles
//
// Fancy button and text field styles used in onboarding/AI views.
//

struct LiquidGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct LiquidGlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Sheets (Popups)
// These are mini screens that slide up over the main app.
// AddMoneyView, CreateGoalView, AddProgressView, TransferView, AI query.
//

// ➕ AddMoneyView
// Asks for an amount and tells the brain to add income.
struct AddMoneyView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    // We use a local text field, then parse it when saving.
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add Money")
                    .font(.title2.weight(.bold))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Add Money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Decimal(string: amountText) {
                            viewModel.addIncome(amount: value)
                        }
                        dismiss()
                    }
                    .bold()
                    .disabled(Decimal(string: amountText) == nil)
                }
            }
        }
    }
}

// 🎯 CreateGoalView
// Lets the user name a goal and set a target amount.
struct CreateGoalView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add a New Goal")
                    .font(.title2.weight(.bold))

                TextField("Goal Name", text: $viewModel.newGoalName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Target Amount", value: $viewModel.newGoalAmount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addGoal(name: viewModel.newGoalName, target: viewModel.newGoalAmount)
                        dismiss()
                    }
                    .bold()
                    .disabled(viewModel.newGoalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              || viewModel.newGoalAmount <= 0)
                }
            }
        }
    }
}

// 📈 AddProgressView
// Adds some money toward a specific goal.
struct AddProgressView: View {
    let goal: FinancialGoal
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Add Progress to")
                    .font(.callout)
                    .foregroundColor(.secondary)
                Text(goal.name)
                    .font(.title3.weight(.semibold))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Decimal(string: amountText) {
                            viewModel.addProgress(to: goal, amount: value)
                        }
                        dismiss()
                    }
                    .bold()
                    .disabled(Decimal(string: amountText) == nil)
                }
            }
        }
    }
}

// 🔁 TransferView
// Moves money from one jar to another.
struct TransferView: View {
    let sourceJar: CoffeeJar?
    let destinationJar: CoffeeJar?
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Transfer Money")
                    .font(.title2.weight(.bold))

                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(sourceJar?.name ?? "Choose Source")
                            .font(.body.weight(.medium))
                    }
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(destinationJar?.name ?? "Choose Destination")
                            .font(.body.weight(.medium))
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
            }
            .padding()
            .navigationTitle("Transfer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Move") {
                        guard
                            let from = sourceJar,
                            let to = destinationJar,
                            let value = Decimal(string: amountText)
                        else { return }
                        viewModel.transfer(from: from, to: to, amount: value)
                        dismiss()
                    }
                    .bold()
                    .disabled(sourceJar == nil || destinationJar == nil || Decimal(string: amountText) == nil)
                }
            }
        }
    }
}

// 🤖 NaturalLanguageQueryView
// Lets the user ask a question like “How much can I save?” and shows an answer.
struct NaturalLanguageQueryView: View {
    @ObservedObject var viewModel: MochaViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var result: QueryResult?
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Ask Mocha AI")
                    .font(.title2.weight(.bold))

                Text("Type a question about your money.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("e.g., How much weekly to reach $300 rent?", text: $query)
                    .textFieldStyle(LiquidGlassTextFieldStyle())

                Button {
                    Task {
                        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        isLoading = true
                        result = await viewModel.processNaturalLanguageQuery(query)
                        isLoading = false
                    }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView().progressViewStyle(.circular)
                        }
                        Image(systemName: "brain.head.profile")
                        Text("Ask AI")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .buttonStyle(.plain)
                .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)

                if let result = result {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("AI Response")
                            .font(.headline.weight(.semibold))
                        Text(result.answer)
                            .font(.body)
                        if !result.suggestedActions.isEmpty {
                            Text("Suggested Actions")
                                .font(.subheadline.weight(.medium))
                            ForEach(result.suggestedActions, id: \.self) { action in
                                Text("• \(action)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
                }

                Spacer()
            }
            .padding()
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - OnboardingView (optional first-time flow)
//
// This is a simple, friendly intro. When done, it calls viewModel.completeOnboarding().
//
struct OnboardingView: View {
    @ObservedObject var viewModel: MochaViewModel
    @State private var currentStep = 0
    @State private var initialBalanceText = ""
    @State private var firstGoalName = ""
    @State private var firstGoalAmountText = ""

    private let steps = ["Welcome", "Balance", "First Goal", "Ready"]

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
                            Image(systemName: "banknote.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            Text("What's your starting balance?")
                                .font(.title2.weight(.semibold))
                                .multilineTextAlignment(.center)
                            TextField("$0.00", text: $initialBalanceText)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(LiquidGlassTextFieldStyle())
                        }
                    case 2:
                        VStack(spacing: 14) {
                            Image(systemName: "target")
                                .font(.system(size: 60))
                                .foregroundColor(.orange)
                            Text("Set Your First Goal")
                                .font(.title2.weight(.semibold))
                            TextField("Goal name (e.g., New Laptop)", text: $firstGoalName)
                                .textFieldStyle(LiquidGlassTextFieldStyle())
                            TextField("Target amount", text: $firstGoalAmountText)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(LiquidGlassTextFieldStyle())
                        }
                    default:
                        VStack(spacing: 14) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                            Text("You're All Set!")
                                .font(.title.weight(.bold))
                                .multilineTextAlignment(.center)
                            Text("Let’s start managing your money with style.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation(.spring()) { currentStep -= 1 }
                        }
                        .buttonStyle(LiquidGlassButtonStyle())
                    }

                    Button(currentStep == steps.count - 1 ? "Get Started" : "Next") {
                        if currentStep == steps.count - 1 {
                            // 🎉 Finish: save initial setup if entered.
                            if let start = Decimal(string: initialBalanceText), start > 0 {
                                viewModel.addIncome(amount: start)
                            }
                            if
                                !firstGoalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                let goalAmount = Decimal(string: firstGoalAmountText),
                                goalAmount > 0
                            {
                                viewModel.newGoalName = firstGoalName
                                viewModel.newGoalAmount = goalAmount
                                viewModel.addGoal(name: firstGoalName, target: goalAmount)
                            }
                            viewModel.completeOnboarding()
                        } else {
                            withAnimation(.spring()) { currentStep += 1 }
                        }
                    }
                    .buttonStyle(LiquidGlassButtonStyle())
                    .disabled(!canProceed)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return !initialBalanceText.isEmpty
        case 2:
            return !firstGoalName.isEmpty && !firstGoalAmountText.isEmpty
        default:
            return true
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}

