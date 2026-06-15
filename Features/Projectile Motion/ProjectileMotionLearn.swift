import SwiftUI

struct ProjectileMotionLearnView: View {
    var viewModel: ProjectileMotionViewModel
    @State private var expandedSection: Int? = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                KeyInsightBanner(
                    insight: "Horizontal and vertical motions are completely independent! This is the secret to understanding projectile motion.",
                    icon: "star.fill",
                    color: .orange
                )

                // Section 0: Your Changes
                ProjectileLearnSection(
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
                            Text("Start the simulation and adjust launch speed or angle. Each change will appear here with a full physics explanation.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.changeEvents.reversed()) { event in
                                ProjectileChangeCard(change: event)
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
                ProjectileLearnSection(
                    number: 1,
                    title: "Live Simulation State",
                    icon: "waveform.path.ecg",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    ProjectileLiveCard(viewModel: viewModel)
                }

                // Section 2: Independent Directions
                ProjectileLearnSection(
                    number: 2,
                    title: "Independent Directions",
                    icon: "figure.archery",
                    color: .indigo,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Projectile motion combines two independent motions: constant velocity horizontally and accelerated motion vertically. The key insight is that these two directions don't affect each other! The horizontal motion continues steadily while gravity pulls the object down vertically.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileCallout(text: "At the peak of the arc, vertical velocity is zero, but horizontal velocity is unchanged!", color: .indigo)

                        Text("How horizontal and vertical components differ:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileBullet(color: .green, text: "Horizontal: No forces act horizontally (ignoring air resistance), so velocity stays constant.")
                        ProjectileBullet(color: .red, text: "Vertical: Gravity pulls downward with constant acceleration g ≈ 9.8 m/s².")
                        ProjectileBullet(color: .orange, text: "Combined Path: A curved trajectory (parabola) emerges from combining these two independent motions.")
                    }
                }

                // Section 3: Trajectory Phases
                ProjectileLearnSection(
                    number: 3,
                    title: "Trajectory Phases",
                    icon: "arrow.up.and.down.circle.fill",
                    color: .blue,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("A typical projectile flight can be broken down into five distinct phases:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileStepCard(steps: [
                            ("1", "Launch", "Initial velocity splits into horizontal (vₓ = v₀ cos θ) and vertical (vᵧ = v₀ sin θ) components. Both start at their maximum values."),
                            ("2", "Ascent", "Gravity slows vertical velocity while horizontal velocity stays constant. The object rises while moving forward."),
                            ("3", "Peak", "Vertical velocity reaches zero! The horizontal velocity is still unchanged. This is the highest point of the flight."),
                            ("4", "Descent", "Vertical velocity becomes negative (downward). Gravity accelerates the object downward, while horizontal speed remains constant."),
                            ("5", "Landing", "The object hits the ground with the same speed as launch, but the velocity vector is now angled downward.")
                        ])
                    }
                }

                // Section 4: Angle and Range (The 45° Sweet Spot)
                ProjectileLearnSection(
                    number: 4,
                    title: "Angle & Range — The 45° Sweet Spot",
                    icon: "angle",
                    color: .green,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("For maximum range on level ground, launch at 45°! This perfectly balances time in air (vertical component) with horizontal speed. Complementary angles (like 30° and 60°) yield the same range because they balance height vs. time differently but achieve the same horizontal distance.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileCallout(text: "Range: R = v₀² sin(2θ) / g", color: .green)

                        ProjectileInsightRow(icon: "arrow.up.right", color: .green, text: "45°: Gives maximum range (sin(2θ) = 1).")
                        ProjectileInsightRow(icon: "arrow.right", color: .cyan, text: "Below 45°: High horizontal velocity but low time in the air.")
                        ProjectileInsightRow(icon: "arrow.up", color: .orange, text: "Above 45°: High peak altitude and long airtime, but low horizontal velocity.")
                        ProjectileInsightRow(icon: "equal", color: .purple, text: "Symmetry: 30° and 60° give the exact same range (complementary angles sum to 90°).")
                    }
                }

                // Section 5: Vector Decomposition
                ProjectileLearnSection(
                    number: 5,
                    title: "Vector Decomposition",
                    icon: "arrow.up.right.and.arrow.down.left",
                    color: .mint,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Any two-dimensional velocity vector can be split into perpendicular parts:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileBullet(color: .green, text: "vₓ = v cos(θ) — projects velocity onto the horizontal axis.")
                        ProjectileBullet(color: .red, text: "vᵧ = v sin(θ) — projects velocity onto the vertical axis.")
                        ProjectileBullet(color: .orange, text: "Recombine components using the Pythagorean theorem: v = √(vₓ² + vᵧ²).")

                        Text("These components evolve independently over time under gravity's influence.")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                    }
                }

                // Section 6: Common Misconceptions
                ProjectileLearnSection(
                    number: 6,
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        ProjectileMisconceptionRow(
                            myth: "At the peak, the projectile stops completely",
                            reality: "Only the vertical velocity is zero at the peak! The horizontal velocity continues unchanged. The object is still moving forward at constant speed."
                        )
                        ProjectileMisconceptionRow(
                            myth: "Horizontal velocity changes during flight",
                            reality: "With no air resistance, horizontal velocity stays perfectly constant throughout the entire flight. Only the vertical component changes due to gravity."
                        )
                        ProjectileMisconceptionRow(
                            myth: "A heavier object will travel farther when thrown",
                            reality: "Mass doesn't affect trajectory! Both heavy and light objects follow the same path when launched with the same velocity and angle (ignoring air resistance)."
                        )
                    }
                }

                // Section 7: Test Your Understanding
                ProjectileLearnSection(
                    number: 7,
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(spacing: 12) {
                        ProjectileQACard(
                            question: "You throw a ball horizontally from a cliff. At the same instant, you drop another ball. Which hits the ground first?",
                            answer: "They hit at the same time! Both start with zero vertical velocity and experience the same downward acceleration (gravity). The horizontal motion of the thrown ball doesn't affect its vertical fall."
                        )
                        ProjectileQACard(
                            question: "If you double the launch speed, how does the range change?",
                            answer: "Range quadruples! Since R = v₀² sin(2θ) / g, doubling v₀ means (2v₀)² = 4v₀², so the range becomes 4 times larger."
                        )
                        ProjectileQACard(
                            question: "At what point in the trajectory is the speed minimum?",
                            answer: "At the peak! The vertical component is zero there, so the speed equals just the horizontal component, which is the minimum speed during flight."
                        )
                    }
                }

                // Section 8: The Equations
                ProjectileLearnSection(
                    number: 8,
                    title: "The Equations",
                    icon: "function",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("The trajectory coordinates and variables can be derived from independent kinematic equations:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        ProjectileEquationCard(lines: [
                            "Horizontal position:  x(t) = v₀ cos(θ) · t",
                            "Vertical position:    y(t) = v₀ sin(θ) · t - ½gt²",
                            "Horizontal speed:     vₓ(t) = v₀ cos(θ)",
                            "Vertical speed:       vᵧ(t) = v₀ sin(θ) - gt",
                            "Total Range:          R = v₀² sin(2θ) / g",
                            "Peak Height:          H = (v₀ sin(θ))² / (2g)"
                        ])
                    }
                }

                // Section 9: Real-World Examples
                ProjectileLearnSection(
                    number: 9,
                    title: "Real-World Examples",
                    icon: "globe",
                    color: .orange,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        ProjectileExampleRow(icon: "basketball.fill", title: "Sports", detail: "Basketball shoots, soccer kicks, and tennis lobs follow parabolic arcs.", color: .green)
                        ProjectileExampleRow(icon: "target", title: "Ballistics and targeting", detail: "Calculations for launch angles in military and archery settings.", color: .red)
                        ProjectileExampleRow(icon: "airplane", title: "Rockets and launches", detail: "Initially follow projectile motion before engines or orbit taking over.", color: .blue)
                        ProjectileExampleRow(icon: "drop.fill", title: "Water fountains", detail: "Designed with specific launch parameters to create perfect arches.", color: .cyan)
                    }
                }

                // Section 10: Experiments to Try
                ProjectileLearnSection(
                    number: 10,
                    title: "Experiments to Try",
                    icon: "flask.fill",
                    color: .pink,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        ProjectileExperimentCard(
                            title: "Maximum Range",
                            steps: ["Set angle to 45°", "Set speed to 20 m/s", "Press Play"],
                            result: "Notice that the projectile reaches the absolute maximum horizontal distance for that speed.",
                            color: .cyan
                        )
                        ProjectileExperimentCard(
                            title: "High Arc vs Low Arc",
                            steps: ["Launch at 30° with speed 20 m/s", "Reset, then launch at 60° with speed 20 m/s"],
                            result: "Both land at the exact same spot! However, the 60° shot goes much higher and stays in the air longer.",
                            color: .orange
                        )
                        ProjectileExperimentCard(
                            title: "Straight Up",
                            steps: ["Set angle to 90°", "Press Play"],
                            result: "The horizontal range is exactly 0. The projectile climbs straight to its peak and falls back to the launcher.",
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

struct ProjectileChangeCard: View {
    let change: ProjectileChangeEvent
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

struct ProjectileLiveCard: View {
    var viewModel: ProjectileMotionViewModel

    var body: some View {
        let pos = viewModel.currentPosition
        let vel = viewModel.currentVelocity

        VStack(spacing: 6) {
            ProjectileLiveRow(label: "Current Time", value: String(format: "%.2f s", viewModel.currentTime), color: .blue)
            ProjectileLiveRow(label: "Horizontal Position x(t)", value: String(format: "%.2f m", pos.x), color: .green)
            ProjectileLiveRow(label: "Vertical Position y(t)", value: String(format: "%.2f m", pos.y), color: .purple)
            ProjectileLiveRow(label: "Launch Speed", value: String(format: "%.1f m/s", viewModel.speed), color: .orange)
            ProjectileLiveRow(label: "Launch Angle", value: String(format: "%.0f°", viewModel.angle), color: .red)
            ProjectileLiveRow(label: "Horizontal Velocity vₓ(t)", value: String(format: "%.2f m/s", vel.dx), color: .green)
            ProjectileLiveRow(label: "Vertical Velocity vᵧ(t)", value: String(format: "%.2f m/s", vel.dy), color: .purple)
            ProjectileLiveRow(label: "Speed Magnitude |v(t)|", value: String(format: "%.2f m/s", viewModel.currentSpeedMagnitude), color: .orange)
            ProjectileLiveRow(label: "Gravity", value: String(format: "%.1f m/s²", viewModel.gravity), color: .red)
        }
    }
}

struct ProjectileLiveRow: View {
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

struct ProjectileLearnSection<Content: View>: View {
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

struct ProjectileCallout: View {
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

struct ProjectileEquationCard: View {
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

struct ProjectileBullet: View {
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

struct ProjectileInsightRow: View {
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

struct ProjectileStepCard: View {
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

struct ProjectileMisconceptionRow: View {
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

struct ProjectileQACard: View {
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

struct ProjectileExampleRow: View {
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

struct ProjectileExperimentCard: View {
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
