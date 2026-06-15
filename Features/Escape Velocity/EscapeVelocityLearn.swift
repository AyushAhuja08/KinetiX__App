import SwiftUI

struct EscapeVelocityLearnView: View {
    var viewModel: EscapeVelocityViewModel
    @State private var expandedSection: Int? = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                KeyInsightBanner(
                    insight: "Escape velocity isn't about going up—it's about having enough energy to reach infinity!",
                    icon: "star.fill",
                    color: .blue
                )

                // Section 0: Your Changes
                EscapeLearnSection(
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
                            Text("Adjust the body speed slider or switch between planets on the Visualize tab. Each change will appear here with a full physics explanation.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.changeEvents.reversed()) { event in
                                EscapeChangeCard(change: event)
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
                EscapeLearnSection(
                    number: 1,
                    title: "Live Simulation State",
                    icon: "waveform.path.ecg",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    EscapeLiveCard(viewModel: viewModel)
                }

                // Section 2: What is Escape Velocity?
                EscapeLearnSection(
                    number: 2,
                    title: "What is Escape Velocity?",
                    icon: "arrow.up.circle.fill",
                    color: .indigo,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Escape velocity is the minimum speed needed to break free from a planet's gravitational pull completely—to reach infinite distance. It's not about direction; you could theoretically escape by launching at any angle, even sideways! What matters is having enough kinetic energy to overcome all the gravitational potential energy binding you to the planet.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeCallout(text: "Formula: v_escape = √(2GM / r)", color: .indigo)

                        Text("Key concepts determining escape velocity:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeBullet(color: .green, text: "Energy bound: Kinetic energy (KE) must equal the magnitude of potential energy (|PE|) at launch.")
                        EscapeBullet(color: .orange, text: "Mass M & Radius r: Larger planets (more mass) need higher escape velocity; larger radius reduces surface gravity and escape speed.")
                        EscapeBullet(color: .red, text: "Altitude: Higher altitudes need lower escape velocity because you are already partway out of the gravity well.")
                        EscapeBullet(color: .purple, text: "Direction independence: Direction doesn't matter (excluding air resistance or planetary blockages)—only speed and energy determine escape.")
                    }
                }

                // Section 3: What Happens at Different Speeds
                EscapeLearnSection(
                    number: 3,
                    title: "What Happens at Different Speeds",
                    icon: "gauge.with.dots.needle.67percent",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("The relation of speed to escape velocity determines the trajectory's behavior:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeBehaviorRow(
                            icon: "arrow.up.circle.fill",
                            title: "Speed ≥ Escape Velocity",
                            behavior: "Body escapes gravity forever",
                            reason: "Kinetic energy meets or exceeds gravitational binding energy - reaches infinity.",
                            color: .blue
                        )

                        EscapeBehaviorRow(
                            icon: "arrow.down.circle.fill",
                            title: "Speed < Escape Velocity",
                            behavior: "Body cannot escape",
                            reason: "Not enough energy to overcome gravity - trajectory curves back.",
                            color: .orange
                        )
                    }
                }

                // Section 4: Energy Transformation
                EscapeLearnSection(
                    number: 4,
                    title: "Energy Transformation — Deep Dive",
                    icon: "bolt.fill",
                    color: .yellow,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("As an object climbs, its kinetic energy converts to potential energy, but total energy remains constant:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeStepCard(steps: [
                            ("1", "At Surface (Launch)", "Maximum kinetic energy (KE = ½mv²). Gravitational potential energy (PE) is large and negative. Total mechanical energy determines the object's fate."),
                            ("2", "Rising Up", "KE converts to PE as the object climbs. Speed decreases, but PE becomes less negative (increases)."),
                            ("3", "At Escape Speed", "Total energy = 0. KE + PE = 0 exactly. The object has just enough energy to reach infinity with zero speed remaining."),
                            ("4", "Below Escape Speed", "Total energy < 0. The object will run out of KE before escaping. Gravity eventually pulls it back down."),
                            ("5", "Above Escape Speed", "Total energy > 0. The object escapes with leftover KE. It will still have speed even at infinite distance!")
                        ])
                    }
                }

                // Section 5: Why Escape Velocities Differ
                EscapeLearnSection(
                    number: 5,
                    title: "Why Escape Velocities Differ",
                    icon: "globe.americas.fill",
                    color: .orange,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Escape velocity is proportional to the square root of mass over radius, resulting in varying speeds for different celestial bodies:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeTable()

                        Text("Black hole boundary: If a body shrinks to the point where its escape velocity equals the speed of light, it becomes a black hole. Not even light can escape!")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                    }
                }

                // Section 6: Trajectory Geometry
                EscapeLearnSection(
                    number: 6,
                    title: "Trajectory Geometry",
                    icon: "circle.dotted.and.circle",
                    color: .teal,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Speed relative to escape velocity determines the geometric shape of the path:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        EscapeBullet(color: .red, text: "Very low speed: Ballistic arc (falls straight back).")
                        EscapeBullet(color: .orange, text: "Orbit range: Elliptical or circular orbits (bound path).")
                        EscapeBullet(color: .yellow, text: "Exactly escape velocity: Parabolic trajectory (escapes to infinity with zero final speed).")
                        EscapeBullet(color: .green, text: "Above escape velocity: Hyperbolic trajectory (escapes with leftover speed).")
                    }
                }

                // Section 7: Common Misconceptions
                EscapeLearnSection(
                    number: 7,
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        EscapeMisconceptionRow(
                            myth: "You must launch straight up to escape",
                            reality: "Direction doesn't matter! You can escape by launching horizontally if you have enough speed. Rockets launch at angles to efficiently combine altitude gain with horizontal acceleration."
                        )
                        EscapeMisconceptionRow(
                            myth: "Heavier objects need more speed to escape",
                            reality: "Escape velocity is the same for all objects regardless of mass! A feather and a boulder need the same speed to escape Earth (ignoring air resistance)."
                        )
                        EscapeMisconceptionRow(
                            myth: "At escape velocity, you stop at infinity",
                            reality: "At exactly escape velocity, you asymptotically approach zero speed at infinity. Above escape velocity, you still have speed left at infinity!"
                        )
                    }
                }

                // Section 8: Test Your Understanding
                EscapeLearnSection(
                    number: 8,
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(spacing: 12) {
                        EscapeQACard(
                            question: "Why is escape velocity from the Moon so much lower than from Earth?",
                            answer: "The Moon has much less mass (about 1/81 of Earth's) and a smaller radius. Since v_escape = √(2GM/r), lower mass means lower escape velocity. This made the Apollo lunar module's return trip much easier!"
                        )
                        EscapeQACard(
                            question: "If you're already in orbit, how much faster must you go to escape?",
                            answer: "You need to increase your speed by a factor of √2 ≈ 1.41. Since v_escape = √2 × v_circular, you need about 41% more speed to escape from a circular orbit."
                        )
                        EscapeQACard(
                            question: "Why does escape velocity decrease with altitude?",
                            answer: "As you rise, you're farther from the planet's center (larger r), and you've already climbed out of some gravitational potential well. Less energy needed to escape means lower escape velocity."
                        )
                    }
                }

                // Section 9: Experiments to Try
                EscapeLearnSection(
                    number: 9,
                    title: "Experiments to Try",
                    icon: "flask.fill",
                    color: .pink,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        EscapeExperimentCard(
                            title: "Earth Escape",
                            steps: ["Set planet to Earth", "Set speed to exactly 11.2 km/s", "Press Play"],
                            result: "Watch the body escape Earth's gravity, its trajectory curving away into deep space.",
                            color: .cyan
                        )
                        EscapeExperimentCard(
                            title: "Moon Escape",
                            steps: ["Set planet to Moon", "Set speed to exactly 2.4 km/s", "Press Play"],
                            result: "Watch it escape easily. The Moon's escape speed is only 21% of Earth's escape velocity!",
                            color: .orange
                        )
                        EscapeExperimentCard(
                            title: "Altitude Advantage",
                            steps: ["Increase altitude to 2000 km", "Compare escape velocity here to surface escape velocity"],
                            result: "Notice how escape velocity drops as altitude increases since you are already higher in the potential well.",
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

struct EscapeChangeCard: View {
    let change: OrbitChangeEvent
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

struct EscapeLiveCard: View {
    var viewModel: EscapeVelocityViewModel

    var body: some View {
        VStack(spacing: 6) {
            EscapeLiveRow(label: "Current Planet", value: viewModel.selectedBody.rawValue, color: viewModel.selectedBody.color)
            EscapeLiveRow(label: "Body Speed", value: String(format: "%.2f km/s", viewModel.bodySpeed), color: .blue)
            EscapeLiveRow(label: "Surface Escape Velocity", value: String(format: "%.1f km/s", viewModel.surfaceEscapeVelocity), color: .red)
            EscapeLiveRow(label: "Escape Vel. at Altitude", value: String(format: "%.2f km/s", viewModel.currentEscapeVelocity), color: .orange)
            EscapeLiveRow(label: "Altitude Above Surface", value: String(format: "%.0f km", viewModel.altitude), color: .green)
            EscapeLiveRow(label: "Current State", value: viewModel.stateDescription, color: viewModel.stateColor)
        }
    }
}

struct EscapeLiveRow: View {
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

struct EscapeLearnSection<Content: View>: View {
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

struct EscapeCallout: View {
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

struct EscapeEquationCard: View {
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

struct EscapeBullet: View {
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

struct EscapeBehaviorRow: View {
    let icon: String
    let title: String
    let behavior: String
    let reason: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.title3).foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline).foregroundStyle(AppTheme.primaryText)
                Text(behavior)
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(color)
                Text(reason)
                    .font(.caption).foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(AppTheme.surfaceBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

struct EscapeTable: View {
    var body: some View {
        VStack(spacing: 1) {
            EscapeTableRow(bodyName: "Sun", speed: "618 km/s", detail: "Enormous mass dominates the solar system.", color: .orange)
            EscapeTableRow(bodyName: "Jupiter", speed: "59.5 km/s", detail: "Massive! 318 times Earth's mass.", color: .yellow)
            EscapeTableRow(bodyName: "Earth", speed: "11.2 km/s", detail: "Large mass, moderate radius.", color: .blue)
            EscapeTableRow(bodyName: "Mars", speed: "5.0 km/s", detail: "Smaller mass and radius than Earth.", color: .red)
            EscapeTableRow(bodyName: "Moon", speed: "2.4 km/s", detail: "Small mass, about 1/81 of Earth's.", color: .gray)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8)).clipped()
    }
}

struct EscapeTableRow: View {
    let bodyName: String
    let speed: String
    let detail: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(bodyName)
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                Spacer()
                Text(speed)
                    .font(.system(.subheadline, design: .monospaced)).fontWeight(.bold)
                    .foregroundStyle(color)
            }
            Text(detail)
                .font(.caption).foregroundStyle(AppTheme.secondaryText)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.07))
    }
}

struct EscapeStepCard: View {
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

struct EscapeMisconceptionRow: View {
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

struct EscapeQACard: View {
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

struct EscapeExperimentCard: View {
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
