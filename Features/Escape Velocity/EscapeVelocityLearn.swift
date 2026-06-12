

import SwiftUI

struct EscapeVelocityLearnView: View {
    var viewModel: EscapeVelocityViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                //Basic Information
                KeyInsightBanner(
                    insight: "Escape velocity isn't about going up—it's about having enough energy to reach infinity!",
                    icon: "star.fill",
                    color: .blue
                )


                ConceptExplanationCard(
                    title: "What is Escape Velocity?",
                    icon: "arrow.up.circle.fill",
                    color: .indigo,
                    explanation: "Escape velocity is the minimum speed needed to break free from a planet's gravitational pull completely—to reach infinite distance. It's not about direction; you could theoretically escape by launching at any angle, even sideways! What matters is having enough kinetic energy to overcome all the gravitational potential energy binding you to the planet.",
                    expandablePoints: [
                        "It's determined by energy: KE (kinetic) must equal |PE| (gravitational potential)",
                        "Formula: v_escape = √(2GM/r), where M is planet mass and r is distance from center",
                        "Larger planets (more mass) need higher escape velocity",
                        "Higher altitudes need lower escape velocity (you're already partway out!)",
                        "Direction doesn't matter—it's purely about speed and energy"
                    ]
                )


                LearnHeroCard(
                    title: "Live Values",
                    icon: "waveform.path.ecg",
                    color: .blue
                ) {
                    VStack(spacing: 12) {
                        LearnValueRow(label: "Current Planet", value: viewModel.selectedBody.rawValue, icon: viewModel.selectedBody.icon, color: viewModel.selectedBody.color)
                        LearnValueRow(label: "Body Speed", value: String(format: "%.2f km/s", viewModel.bodySpeed), icon: "speedometer", color: .blue)
                        LearnValueRow(label: "Surface Escape Velocity", value: String(format: "%.1f km/s", viewModel.surfaceEscapeVelocity), icon: "arrow.up.circle.fill", color: .red)
                        LearnValueRow(label: "Escape Vel. at Altitude", value: String(format: "%.2f km/s", viewModel.currentEscapeVelocity), icon: "arrow.up.circle", color: .orange)
                        LearnValueRow(label: "Altitude Above Surface", value: String(format: "%.0f km", viewModel.altitude), icon: "ruler", color: .green)
                        LearnValueRow(label: "Current State", value: viewModel.stateDescription, icon: statusIcon, color: viewModel.stateColor)
                    }

                    Text("Current orbital parameters and velocities")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }


                LearnCurrentStateCard(
                    title: "What's Happening Now",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .purple
                ) {
                    VStack(spacing: 8) {
                        InfoRow(
                            label: "Speed / Escape Velocity",
                            value: String(format: "%.1f%%", (viewModel.bodySpeed / viewModel.surfaceEscapeVelocity) * 100)
                        )
                        InfoRow(
                            label: "Altitude",
                            value: String(format: "%.0f km above %@", viewModel.altitude, viewModel.selectedBody.rawValue)
                        )

                        Divider()
                            .padding(.vertical, 4)

                        Text(currentStateExplanation)
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }


                PhysicsChangesSection(
                    title: viewModel.changeEvents.isEmpty ? "Your Changes (none yet)" : "Your Changes (\(viewModel.changeEvents.count))",
                    badge: viewModel.changeEvents.isEmpty ? nil : "\(viewModel.changeEvents.count)",
                    isEmpty: viewModel.changeEvents.isEmpty,
                    emptyPrompt: "Adjust the body speed slider or switch between planets on the Visualize tab. Each change will appear here with a full physics explanation.",
                    onClear: { viewModel.changeEvents.removeAll() }
                ) {
                    ForEach(viewModel.changeEvents.reversed()) { event in
                        PhysicsChangeCard(
                            parameter: event.changedParameter,
                            headline: event.headline,
                            explanation: event.physicsExplanation,
                            icon: event.paramIcon,
                            color: event.paramColor,
                            timestamp: String(format: "t = %.2f s", event.time)
                        )
                    }
                }


                LearnStateComparisonCard(
                    title: "What Happens at Different Speeds",
                    icon: "gauge.with.dots.needle.67percent",
                    color: .cyan,
                    states: [
                        (
                            icon: "arrow.up.circle.fill",
                            title: "Speed ≥ Escape Velocity (≥\(String(format: "%.1f", viewModel.surfaceEscapeVelocity)) km/s)",
                            behavior: "Body escapes \(viewModel.selectedBody.rawValue)'s gravity forever",
                            reason: "Kinetic energy exceeds gravitational binding energy - reaches infinity",
                            color: .blue
                        ),
                        (
                            icon: "arrow.down.circle.fill",
                            title: "Speed < Escape Velocity (<\(String(format: "%.1f", viewModel.surfaceEscapeVelocity)) km/s)",
                            behavior: "Body cannot escape - falls back to \(viewModel.selectedBody.rawValue)",
                            reason: "Not enough energy to overcome gravity - trajectory curves back",
                            color: .orange
                        )
                    ]
                )


                LearnPlanetExamplesCard(
                    title: "Real-World Examples",
                    icon: "globe.americas.fill",
                    color: .orange,
                    planetExamples: [
                        (
                            planet: "Earth (11.2 km/s)",
                            color: .blue,
                            examples: [
                                ("airplane.departure", "Apollo missions: Reached 11.2 km/s to escape Earth's gravity"),
                                ("sparkles", "Voyager spacecraft: Launched at escape velocity, now in interstellar space")
                            ]
                        ),
                        (
                            planet: "Moon (2.4 km/s)",
                            color: .gray,
                            examples: [
                                ("moon.stars", "Much easier to escape - only 21% of Earth's escape velocity!"),
                                ("figure.walk", "Lunar Module needed far less fuel to leave Moon than Earth")
                            ]
                        ),
                        (
                            planet: "Mars (5.0 km/s)",
                            color: .red,
                            examples: [
                                ("figure.walk", "45% of Earth's escape velocity - easier to launch from Mars"),
                                ("sparkles", "Future Mars missions will need less fuel to return to Earth")
                            ]
                        )
                    ]
                )


                StepByStepCard(
                    title: "Energy Transformation: What's Really Happening",
                    icon: "bolt.fill",
                    color: .yellow,
                    steps: [
                        (phase: "At Surface (Launch)", description: "Maximum kinetic energy (KE = ½mv²). Gravitational PE is large and negative. Total energy determines fate."),
                        (phase: "Rising Up", description: "KE converts to PE as object climbs. Speed decreases, but PE becomes less negative (increases)."),
                        (phase: "At Escape Speed", description: "Total energy = 0. KE + PE = 0 exactly. Object has just enough energy to reach infinity with zero speed remaining."),
                        (phase: "Below Escape Speed", description: "Total energy < 0. Object will run out of KE before escaping. Gravity pulls it back down."),
                        (phase: "Above Escape Speed", description: "Total energy > 0. Object escapes with leftover KE. It will still have speed even at infinite distance!")
                    ]
                )


                ConceptExplanationCard(
                    title: "Why Different Speeds Create Different Paths",
                    icon: "circle.dotted.and.circle",
                    color: .cyan,
                    explanation: "Speed determines trajectory! Below escape velocity, you're gravitationally bound—your path curves back. At exactly escape velocity, you follow a parabolic escape trajectory reaching infinity with zero final speed. Above escape velocity, you follow a hyperbolic path and escape with speed to spare.",
                    expandablePoints: [
                        "Very low speed: Falls straight back (ballistic arc)",
                        "Medium speed: Elliptical orbit around planet",
                        "Circular orbit speed: √(GM/r) - stays at constant altitude",
                        "Escape velocity: √(2GM/r) = √2 × orbital speed",
                        "Hyperbolic trajectory: Exceeds escape velocity, escapes fast"
                    ]
                )


                ComparisonTableCard(
                    title: "Why Escape Velocities Differ",
                    icon: "globe.americas.fill",
                    color: .orange,
                    headers: ["Body", "Escape Velocity", "Why?"],
                    rows: [
                        ["Earth", "11.2 km/s", "Large mass, medium radius"],
                        ["Moon", "2.4 km/s", "Much smaller mass (~1/81 Earth)"],
                        ["Mars", "5.0 km/s", "Smaller mass & radius than Earth"],
                        ["Jupiter", "60 km/s", "Massive! 318× Earth's mass"],
                        ["Sun", "618 km/s", "Enormous mass dominates system"]
                    ]
                )


                MisconceptionCard(
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    misconceptions: [
                        (
                            myth: "You must launch straight up to escape",
                            reality: "Direction doesn't matter! You can escape by launching horizontally if you have enough speed. Rockets launch at angles to efficiently combine altitude gain with horizontal acceleration."
                        ),
                        (
                            myth: "Heavier objects need more speed to escape",
                            reality: "Escape velocity is the same for all objects regardless of mass! A feather and a boulder need the same speed to escape Earth (ignoring air resistance)."
                        ),
                        (
                            myth: "At escape velocity, you stop at infinity",
                            reality: "At exactly escape velocity, you asymptotically approach zero speed at infinity. Above escape velocity, you still have speed left at infinity!"
                        )
                    ]
                )


                InteractiveQuestionCard(
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    questions: [
                        QA(
                            question: "Why is escape velocity from the Moon so much lower than from Earth?",
                            answer: "The Moon has much less mass (about 1/81 of Earth's) and a smaller radius. Since v_escape = √(2GM/r), lower mass means lower escape velocity. This made the Apollo lunar module's return trip much easier!"
                        ),
                        QA(
                            question: "If you're already in orbit, how much faster must you go to escape?",
                            answer: "You need to increase your speed by a factor of √2 ≈ 1.41. Since v_escape = √2 × v_circular, you need about 41% more speed to escape from a circular orbit."
                        ),
                        QA(
                            question: "Why does escape velocity decrease with altitude?",
                            answer: "As you rise, you're farther from the planet's center (larger r), and you've already climbed out of some gravitational potential well. Less energy needed to escape means lower escape velocity."
                        )
                    ]
                )


                LearnTipCard(
                    title: "Try This!",
                    icon: "lightbulb.fill",
                    color: .yellow,
                    tips: [
                        "Switch between Earth, Moon, and Mars to compare escape velocities",
                        "Moon: Try 2.5 km/s to see it barely escape (much easier than Earth!)",
                        "Earth: Set to 11.2 km/s - watch it barely escape",
                        "Mars: Try 5.0 km/s - moderate escape velocity",
                        "Watch both escape velocities: Surface (fixed) vs Current altitude (changes)",
                        "Notice: Higher altitude = lower escape velocity needed",
                        "Check Visualize tab's Focus mode to see graphs of altitude, velocity, and distance over time!"
                    ]
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    private var statusIcon: String {
        switch viewModel.orbitalState {
        case .stable: return "checkmark.circle.fill"
        case .escaping: return "arrow.up.circle.fill"
        case .decaying: return "arrow.down.circle.fill"
        }
    }

    private var currentStateExplanation: String {
        let planetName = viewModel.selectedBody.rawValue
        let surfaceVel = viewModel.surfaceEscapeVelocity

        switch viewModel.orbitalState {
        case .stable:
            return "The body is moving at a stable velocity for this altitude. While this isn't about stable orbits in this simulation, at certain speeds objects can maintain orbits around \(planetName)."
        case .escaping:
            return String(format: "The body's speed (%.2f km/s) meets or exceeds %@'s surface escape velocity (%.1f km/s)! It has enough kinetic energy to completely overcome %@'s gravitational pull. The trajectory will continue outward indefinitely, spiraling away until it escapes to infinity and never returns.", viewModel.bodySpeed, planetName, surfaceVel, planetName)
        case .decaying:
            return String(format: "The body's speed (%.2f km/s) is below %@'s surface escape velocity (%.1f km/s). Without sufficient energy to escape %@'s gravitational field, the body's trajectory curves back. It will spiral inward, losing altitude continuously until it falls back to the surface.", viewModel.bodySpeed, planetName, surfaceVel, planetName)
        }
    }

    private func stateText(for state: OrbitalState) -> String {
        switch state {
        case .stable: return "Stable Orbit"
        case .escaping: return "Escaping to Infinity"
        case .decaying: return "Decaying Orbit"
        }
    }
}

struct LearnCurrentStateCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content

    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            content
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 180)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnStateComparisonCard: View {
    let title: String
    let icon: String
    let color: Color
    let states: [(icon: String, title: String, behavior: String, reason: String, color: Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(spacing: 12) {
                ForEach(Array(states.enumerated()), id: \.offset) { _, state in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: state.icon)
                                .foregroundStyle(.white)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(state.color)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(state.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(state.behavior)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                Text(state.reason)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            Text("Note: At 400 km altitude (ISS), escape velocity is ~10.9 km/s, slightly less than at surface")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 180)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnPlanetExamplesCard: View {
    let title: String
    let icon: String
    let color: Color
    let planetExamples: [(planet: String, color: Color, examples: [(String, String)])]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(planetExamples.enumerated()), id: \.offset) { index, planetGroup in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(planetGroup.planet)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(planetGroup.color)

                        ForEach(Array(planetGroup.examples.enumerated()), id: \.offset) { _, example in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: example.0)
                                    .font(.subheadline)
                                    .foregroundStyle(color)
                                    .frame(width: 22)
                                Text(example.1)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary.opacity(0.85))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    if index < planetExamples.count - 1 {
                        Divider()
                            .padding(.vertical, 4)
                    }
                }

                Divider()
                    .padding(.vertical, 4)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "tornado")
                        .font(.subheadline)
                        .foregroundStyle(color)
                        .frame(width: 22)
                    Text("Black hole: Escape velocity exceeds speed of light - nothing escapes!")
                        .font(.subheadline)
                        .foregroundStyle(.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 180)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnTipCard: View {
    let title: String
    let icon: String
    let color: Color
    let tips: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(tips.enumerated()), id: \.offset) { _, tip in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(color)
                            .frame(width: 8, height: 8)
                            .padding(.top, 6)
                        Text(tip)
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 180)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}
