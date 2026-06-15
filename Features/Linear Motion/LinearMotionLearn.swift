import SwiftUI

struct LinearMotionLearnView: View {
    var viewModel: LinearMotionViewModel
    @State private var expandedSection: Int? = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                KeyInsightBanner(
                    insight: "Linear motion is the foundation of all physics. Master this, and you'll understand how everything moves!",
                    icon: "star.fill",
                    color: .blue
                )

                // Section 0: Your Changes
                LinearLearnSection(
                    number: 0,
                    title: viewModel.changeEvents.isEmpty ? "Your Changes (none yet)" : "Your Changes (\(viewModel.changeEvents.count))",
                    icon: "pencil.and.list.clipboard",
                    color: .yellow,
                    badge: viewModel.changeEvents.isEmpty ? nil : "\(viewModel.changeEvents.count)",
                    expandedSection: $expandedSection
                ) {
                    if viewModel.changeEvents.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "hand.point.up.left")
                                .font(.largeTitle)
                                .foregroundStyle(AppTheme.tertiaryText)
                            Text("Adjust any slider on the Visualize tab. Each change will appear here with a full physics explanation.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.changeEvents.reversed()) { event in
                                LinearChangeCard(change: event)
                            }

                            Button(action: {
                                withAnimation { viewModel.changeEvents.removeAll() }
                            }) {
                                Label("Clear History", systemImage: "trash")
                                    .font(.caption)
                                    .foregroundStyle(.red.opacity(0.8))
                            }
                            .padding(.top, 4)
                        }
                    }
                }

                // Section 1: Live Simulation State
                LinearLearnSection(
                    number: 1,
                    title: "Live Simulation State",
                    icon: "waveform.path.ecg",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    LinearLiveCard(viewModel: viewModel)
                }

                // Section 2: What is Linear Motion?
                LinearLearnSection(
                    number: 2,
                    title: "What is Linear Motion?",
                    icon: "arrow.right.circle.fill",
                    color: .indigo,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Linear motion is movement along a straight line. It's the simplest form of motion, where an object's position changes in one dimension over time. Think of a car driving on a straight highway or a ball rolling in a single direction.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        LinearCallout(text: "Position, velocity, and acceleration are the fundamental elements describing any straight-line path.", color: .indigo)

                        Text("Three primary values describe this motion:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        LinearBullet(color: .green, text: "Position (s) — Where the object is located relative to the starting point.")
                        LinearBullet(color: .orange, text: "Velocity (v) — How fast the position changes over time (the rate of change of position).")
                        LinearBullet(color: .red, text: "Acceleration (a) — How fast velocity changes (the rate of change of velocity).")

                        Text("These quantities are mathematically connected: velocity is the slope (derivative) of position, and acceleration is the slope (derivative) of velocity.")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                    }
                }

                // Section 3: Reading the Graphs
                LinearLearnSection(
                    number: 3,
                    title: "Reading the Graphs",
                    icon: "chart.xyaxis.line",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Looking at the plots of Position, Velocity, and Acceleration vs. Time reveals distinct visual behaviors:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        LinearInsightRow(icon: "arrow.up.right", color: .green, text: "Positive slope on position plot: Moving forward (positive velocity)")
                        LinearInsightRow(icon: "arrow.down.right", color: .red, text: "Negative slope on position plot: Moving backward (negative velocity)")
                        LinearInsightRow(icon: "gauge.high", color: .orange, text: "Steeper slope: Speeding up - velocity has a greater magnitude")
                        LinearInsightRow(icon: "minus", color: .purple, text: "Horizontal line on position plot: Object is stationary (zero velocity)")
                        LinearInsightRow(icon: "rotate.right", color: .cyan, text: "Curved line on position plot: Velocity is changing, meaning acceleration is present")
                    }
                }

                // Section 4: Calculus Connection
                LinearLearnSection(
                    number: 4,
                    title: "Calculus Connection — Deep Dive",
                    icon: "infinity",
                    color: .mint,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Position, velocity, and acceleration are connected through derivatives (slopes) and integrals (areas under curves):")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        LinearStepCard(steps: [
                            ("1", "Position → Velocity", "v = ds/dt\nThe slope of the position-time graph gives the instantaneous velocity at that moment."),
                            ("2", "Velocity → Acceleration", "a = dv/dt\nThe slope of the velocity-time graph gives the instantaneous acceleration."),
                            ("3", "Velocity → Displacement", "Δs = ∫ v dt\nThe area under the velocity-time graph equals the total change in position (displacement)."),
                            ("4", "Acceleration → Velocity Change", "Δv = ∫ a dt\nThe area under the acceleration-time graph gives the total change in velocity.")
                        ])
                    }
                }

                // Section 5: Common Misconceptions
                LinearLearnSection(
                    number: 5,
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        LinearMisconceptionRow(
                            myth: "Negative acceleration always means slowing down",
                            reality: "Negative acceleration means acceleration in the negative direction. If you're moving backward (negative velocity), negative acceleration actually speeds you up in that direction!"
                        )
                        LinearMisconceptionRow(
                            myth: "Zero acceleration means the object isn't moving",
                            reality: "Zero acceleration means velocity isn't changing. The object could be moving at constant velocity! Think of cruise control in a car."
                        )
                        LinearMisconceptionRow(
                            myth: "Velocity and speed are the same thing",
                            reality: "Velocity includes direction (positive or negative), while speed is just the magnitude. An object moving backward at 10 m/s has velocity -10 m/s but speed 10 m/s."
                        )
                    }
                }

                // Section 6: Test Your Understanding
                LinearLearnSection(
                    number: 6,
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(spacing: 12) {
                        LinearQACard(
                            question: "If position vs time graph is a straight line, what can you say about acceleration?",
                            answer: "Acceleration must be zero! A straight line means constant velocity, and constant velocity means no acceleration."
                        )
                        LinearQACard(
                            question: "Can an object have velocity in one direction and acceleration in the opposite direction?",
                            answer: "Yes! This is exactly what happens when you're slowing down. For example, moving forward (positive velocity) while braking (negative acceleration)."
                        )
                        LinearQACard(
                            question: "What does it mean when velocity graph crosses the time axis?",
                            answer: "The object changes direction! It stops momentarily (zero velocity) and then starts moving in the opposite direction."
                        )
                    }
                }

                // Section 7: The Equations
                LinearLearnSection(
                    number: 7,
                    title: "The Equations",
                    icon: "function",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("For motion with constant acceleration, the SUVAT kinematic equations link distance, speed, and acceleration:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        LinearEquationCard(lines: [
                            "Position:       s(t) = s₀ + v₀t + ½at²",
                            "Velocity:       v(t) = v₀ + at",
                            "Acceleration:   a(t) = constant",
                            "Time-independent: v² = v₀² + 2as"
                        ])
                    }
                }

                // Section 8: Real-World Examples
                LinearLearnSection(
                    number: 8,
                    title: "Real-World Examples",
                    icon: "car.fill",
                    color: .orange,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        LinearExampleRow(icon: "car.fill", title: "Car accelerating from rest", detail: "Initial velocity is zero (v₀ = 0), acceleration is positive (a > 0).", color: .green)
                        LinearExampleRow(icon: "hand.raised.fill", title: "Car braking", detail: "Initial velocity is forward (v₀ > 0), acceleration is backward (a < 0).", color: .red)
                        LinearExampleRow(icon: "arrow.up.circle.fill", title: "Object thrown upward", detail: "v₀ > 0, acceleration is gravity downward (a = -9.8 m/s²).", color: .orange)
                        LinearExampleRow(icon: "building.2.fill", title: "Elevator", detail: "Phases of positive acceleration, constant velocity, and negative acceleration.", color: .blue)
                    }
                }

                // Section 9: Experiments to Try
                LinearLearnSection(
                    number: 9,
                    title: "Experiments to Try",
                    icon: "flask.fill",
                    color: .pink,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        LinearExperimentCard(
                            title: "Constant Velocity",
                            steps: ["Set acceleration to exactly 0 m/s²", "Set initial velocity to 5 m/s", "Press Play"],
                            result: "Watch the velocity graph stay perfectly flat. Position is a straight, slanted line.",
                            color: .cyan
                        )
                        LinearExperimentCard(
                            title: "Slowing to a Stop & Reversing",
                            steps: ["Set initial velocity to 6 m/s", "Set acceleration to -2 m/s²", "Press Play"],
                            result: "At t = 3s, velocity reaches zero and the object stops. Then it reverses direction and velocity goes negative.",
                            color: .orange
                        )
                        LinearExperimentCard(
                            title: "Rapid Acceleration",
                            steps: ["Set acceleration to 5 m/s²", "Set initial velocity to 0 m/s", "Press Play"],
                            result: "The position curve bends sharply upward as velocity increases rapidly.",
                            color: .green
                        )
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}

// MARK: - Subviews

struct LinearChangeCard: View {
    let change: LinearChangeEvent
    @State private var expanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } }) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(change.paramColor.opacity(0.15)).frame(width: 32, height: 32)
                        Image(systemName: change.paramIcon)
                            .font(.caption).foregroundStyle(change.paramColor)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(change.changedParameter)
                            .font(.caption2).fontWeight(.semibold)
                            .foregroundStyle(change.paramColor)
                        Text(change.headline)
                            .font(.caption).foregroundStyle(AppTheme.primaryText)
                            .lineLimit(2)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption2).foregroundStyle(AppTheme.tertiaryText)
                }
                .padding(10)
            }

            if expanded {
                Divider().background(change.paramColor.opacity(0.2))
                VStack(alignment: .leading, spacing: 8) {
                    Text(change.physicsExplanation)
                        .font(.caption)
                        .foregroundStyle(AppTheme.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(change.paramColor.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(change.paramColor.opacity(0.2), lineWidth: 1))
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}

struct LinearLiveCard: View {
    var viewModel: LinearMotionViewModel

    var body: some View {
        VStack(spacing: 6) {
            LinearLiveRow(label: "Current Time", value: String(format: "%.2f s", viewModel.currentTime), color: .blue)
            LinearLiveRow(label: "Distance s(t)", value: String(format: "%.2f m", viewModel.currentDistance), color: .green)
            LinearLiveRow(label: "Velocity v(t)", value: String(format: "%.2f m/s", viewModel.currentVelocity), color: .orange)
            LinearLiveRow(label: "Acceleration a(t)", value: String(format: "%.2f m/s²", viewModel.currentAcceleration), color: .red)
            LinearLiveRow(label: "Current State", value: viewModel.currentInsight, color: .purple)
        }
    }
}

struct LinearLiveRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(AppTheme.surfaceBackground)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct LinearLearnSection<Content: View>: View {
    let number: Int
    let title: String
    let icon: String
    let color: Color
    let badge: String?
    @Binding var expandedSection: Int?
    @ViewBuilder let content: () -> Content

    var isExpanded: Bool { expandedSection == number }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    expandedSection = isExpanded ? nil : number
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(color.opacity(0.15)).frame(width: 34, height: 34)
                        Image(systemName: icon)
                            .font(.callout).foregroundStyle(color)
                    }
                    Text(title)
                        .font(.headline).fontWeight(.semibold)
                        .foregroundStyle(AppTheme.primaryText)
                        .lineLimit(2)
                    Spacer()
                    if let badge = badge {
                        Text(badge)
                            .font(.caption2).fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Capsule().fill(color))
                    }
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption).foregroundStyle(AppTheme.secondaryText)
                }
                .padding(14)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider().background(color.opacity(0.2))
                    content().padding(16)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(isExpanded ? 0.3 : 0.1), lineWidth: 1))
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}

struct LinearCallout: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.3), lineWidth: 1))
    }
}

struct LinearEquationCard: View {
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(line.isEmpty ? .clear : .white.opacity(0.85))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(hex: "#0D1525"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct LinearBullet: View {
    let color: Color
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle().fill(color.opacity(0.7)).frame(width: 7, height: 7).padding(.top, 5)
            Text(text)
                .font(.subheadline).foregroundStyle(AppTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct LinearInsightRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.caption).foregroundStyle(color)
                .frame(width: 16, height: 16).padding(.top, 2)
            Text(text)
                .font(.subheadline).foregroundStyle(AppTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct LinearStepCard: View {
    let steps: [(String, String, String)]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { i, step in
                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        Circle().fill(AppTheme.primaryAccent.opacity(0.2)).frame(width: 24, height: 24)
                        Text(step.0).font(.caption2).fontWeight(.bold).foregroundStyle(AppTheme.primaryAccent)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(step.1)
                            .font(.caption).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                        Text(step.2)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundStyle(AppTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
                .padding(10)
                if i < steps.count - 1 {
                    Divider().background(AppTheme.tertiaryText.opacity(0.3)).padding(.leading, 44)
                }
            }
        }
        .background(Color(hex: "#0D1525"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct LinearMisconceptionRow: View {
    let myth: String
    let reality: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "xmark.octagon.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.top, 3)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Misconception")
                        .font(.caption2).fontWeight(.bold).foregroundStyle(.red)
                    Text(myth)
                        .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                }
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
                    .padding(.top, 3)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Reality")
                        .font(.caption2).fontWeight(.bold).foregroundStyle(.green)
                    Text(reality)
                        .font(.caption).foregroundStyle(AppTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(12)
        .background(Color(hex: "#0D1525"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}

struct LinearQACard: View {
    let question: String
    let answer: String
    @State private var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(AppTheme.primaryText)

            if revealed {
                Text(answer)
                    .font(.caption)
                    .foregroundStyle(AppTheme.primaryAccent)
                    .transition(.opacity)
            } else {
                Button(action: { withAnimation { revealed = true } }) {
                    Text("Tap to reveal answer")
                        .font(.caption2).fontWeight(.bold)
                        .foregroundStyle(AppTheme.primaryAccent)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(AppTheme.primaryAccent.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surfaceBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppTheme.primaryAccent.opacity(0.15), lineWidth: 1))
    }
}

struct LinearExampleRow: View {
    let icon: String
    let title: String
    let detail: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.caption).foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                Text(detail)
                    .font(.caption).foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(10)
        .background(AppTheme.surfaceBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct LinearExperimentCard: View {
    let title: String
    let steps: [String]
    let result: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: "flask.fill")
                .font(.subheadline).fontWeight(.bold).foregroundStyle(color)

            VStack(alignment: .leading, spacing: 3) {
                ForEach(Array(steps.enumerated()), id: \.offset) { i, step in
                    HStack(alignment: .top, spacing: 6) {
                        Text("\(i+1).")
                            .font(.caption2).fontWeight(.bold).foregroundStyle(color)
                        Text(step)
                            .font(.caption).foregroundStyle(AppTheme.primaryText)
                    }
                }
            }

            Spacer(minLength: 0)

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.caption).foregroundStyle(color)
                Text(result)
                    .font(.caption).foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
        .background(color.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
}
