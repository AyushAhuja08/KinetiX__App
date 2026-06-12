

import SwiftUI

struct OrbitalMechanicsLearnView: View {
    var viewModel: OrbitalMechanicsViewModel
    @State private var expandedSection: Int? = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {


                KeyInsightBanner(
                    insight: "An orbit is just free-fall where you keep missing the planet. Change the speed and watch the physics unfold!",
                    icon: "globe.europe.africa.fill",
                    color: .cyan
                )




                OrbitalLearnSection(
                    number: 0,
                    title: viewModel.parameterChanges.isEmpty ? "Your Changes (none yet)" : "Your Changes (\(viewModel.parameterChanges.count))",
                    icon: "pencil.and.list.clipboard",
                    color: .yellow,
                    badge: viewModel.parameterChanges.isEmpty ? nil : "\(viewModel.parameterChanges.count)",
                    expandedSection: $expandedSection
                ) {
                    if viewModel.parameterChanges.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "hand.point.up.left")
                                .font(.largeTitle)
                                .foregroundStyle(AppTheme.tertiaryText)
                            Text("Adjust any slider, preset, or integrator on the Visualize tab. Each change will appear here with a full physics explanation of what it means.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(viewModel.parameterChanges) { change in
                                OrbitalChangeCard(change: change)
                            }

                            Button(action: {
                                withAnimation { viewModel.parameterChanges.removeAll() }
                            }) {
                                Label("Clear History", systemImage: "trash")
                                    .font(.caption)
                                    .foregroundStyle(.red.opacity(0.8))
                            }
                            .padding(.top, 4)
                        }
                    }
                }




                OrbitalLearnSection(
                    number: 1,
                    title: "Live Simulation State",
                    icon: "waveform.path.ecg",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    OrbitalLiveCard(viewModel: viewModel)
                }


                //Examples

                OrbitalLearnSection(
                    number: 2,
                    title: "Why Orbits Happen",
                    icon: "arrow.triangle.2.circlepath",
                    color: .cyan,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Imagine throwing a ball horizontally from a tall tower. Gravity pulls it down and it curves into the ground. Throw it harder — it curves less steeply and lands farther away. Now imagine throwing it so hard that the curvature of its path matches the curvature of Earth's surface.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        OrbitalCallout(text: "At that exact speed, the ball is constantly falling — but the ground keeps curving away beneath it. It never lands. It's in orbit.", color: .cyan)

                        Text("Two things are always competing:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        OrbitalBullet(color: .green, text: "Tangential velocity — the 'sideways' speed that carries the satellite around the planet")
                        OrbitalBullet(color: .red, text: "Gravitational acceleration — the inward pull that continuously curves the path toward the center")

                        Text("When these two are perfectly matched, the orbit is circular. Any imbalance produces an ellipse, a crash, or an escape trajectory.")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)

                        OrbitalCallout(
                            text: "Try in sim: set speed exactly to the 'Circular' hint value at 90° angle → perfect circle",
                            color: .green
                        )
                    }
                }




                OrbitalLearnSection(
                    number: 3,
                    title: "Circular Orbit Speed",
                    icon: "circle.dashed",
                    color: .green,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("For a stable circular orbit, the gravitational force must equal the centripetal force needed to maintain circular motion:")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        OrbitalEquationCard(lines: [
                            "Gravitational:    F = GMm / r²",
                            "Centripetal:       F = mv² / r",
                            "Equal them:       GMm/r² = mv²/r",
                            "Cancel m, mul r:  GM/r = v²",
                            "Solve:             v = √(GM/r)"
                        ])

                        OrbitalCallout(text: "v_circular = √(GM / r)", color: .green)

                        OrbitalInsightRow(icon: "arrow.up", color: .green,
                            text: "Bigger planet mass M → higher orbital speed (stronger gravity needs more speed to balance)")
                        OrbitalInsightRow(icon: "arrow.right", color: .purple,
                            text: "Larger radius r → lower orbital speed (weaker gravity at distance, outer planets move slower)")

                        Text("Your current values:")
                            .font(.caption).fontWeight(.semibold).foregroundStyle(AppTheme.secondaryText)
                        OrbitalEquationCard(lines: [
                            "Planet: \(viewModel.preset.rawValue)",
                            "Altitude: \(viewModel.altitudeDisplay)  •  Radius: \(viewModel.radiusDisplay)",
                            "v_circ = \(viewModel.circularDisplay)",
                            "Your launch speed = \(viewModel.launchSpeedDisplay)"
                        ])
                    }
                }




                OrbitalLearnSection(
                    number: 4,
                    title: "Escape Velocity",
                    icon: "arrow.up.forward",
                    color: .orange,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Escape velocity is the minimum speed at which a projectile can be launched so it never returns — regardless of direction. We derive it from energy conservation.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        OrbitalEquationCard(lines: [
                            "At escape, total energy = 0:",
                            "  KE + PE = 0",
                            "  ½mv² - GMm/r = 0",
                            "  v² = 2GM/r",
                            "  v_escape = √(2GM/r)"
                        ])

                        OrbitalCallout(text: "v_escape = √2 × v_circular ≈ 1.414 × v_circular", color: .orange)

                        OrbitalInsightRow(icon: "equal", color: .cyan,
                            text: "Escape is always √2 times circular speed — a beautiful, universal ratio")
                        OrbitalInsightRow(icon: "arrow.up.and.down", color: .orange,
                            text: "Direction doesn't matter — only speed determines whether you escape")
                        OrbitalInsightRow(icon: "mountain.2", color: .green,
                            text: "Higher altitude → lower escape speed (you've already done some of the climbing)")

                        Text("Your current values:")
                            .font(.caption).fontWeight(.semibold).foregroundStyle(AppTheme.secondaryText)
                        OrbitalEquationCard(lines: [
                            "Planet: \(viewModel.preset.rawValue)  •  Altitude: \(viewModel.altitudeDisplay)",
                            "v_circ   = \(viewModel.circularDisplay)",
                            "v_escape = √2 × v_circ = \(viewModel.escapeDisplay)",
                            "Surface escape = \(viewModel.surfaceEscapeDisplay)",
                            "Your speed = \(viewModel.launchSpeedDisplay)",
                            "Ratio = \(String(format: "%.3f", viewModel.realSpeedKmS / max(viewModel.realEscapeSpeedKmS, 0.001)))× escape"
                        ])
                    }
                }




                OrbitalLearnSection(
                    number: 5,
                    title: "Energy & Orbit Classification",
                    icon: "bolt.circle.fill",
                    color: .purple,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Total mechanical energy completely determines the orbit type. This is one of the most powerful results in orbital mechanics — one number tells you everything about the trajectory's fate.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        OrbitalEnergyTable()

                        Text("Why is potential energy negative?")
                            .font(.headline).foregroundStyle(AppTheme.primaryText)
                        Text("We set PE = 0 at infinite distance. Closer to the planet means lower PE (the satellite has \"fallen\" from infinity). A satellite sitting at infinity has zero PE, so closer positions must be negative. To push a satellite away to infinity, you must add energy — meaning it must currently have stored negative potential energy.")
                            .font(.subheadline).foregroundStyle(AppTheme.secondaryText)

                        OrbitalCallout(text: "Virial theorem: for a circular orbit, KE = -½ × PE and Total E = -KE", color: .purple)

                        Text("Live energy breakdown:")
                            .font(.caption).fontWeight(.semibold).foregroundStyle(AppTheme.secondaryText)
                        OrbitalEquationCard(lines: [
                            "KE  = ½v²  = \(String(format: "%.2f km²/s²", viewModel.kineticEnergyReal))",
                            "PE  = -GM/r = \(String(format: "%.2f km²/s²", viewModel.potentialEnergyReal))",
                            "E   = \(String(format: "%.2f km²/s²", viewModel.totalEnergyReal))  → \(viewModel.orbitType.rawValue)",
                            "",
                            "Earth ISS orbit: KE≈29.4, PE≈-58.8, E≈-29.4"
                        ])
                    }
                }




                OrbitalLearnSection(
                    number: 6,
                    title: "Semi-Implicit Euler — Deep Dive",
                    icon: "function",
                    color: .teal,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {

                        Text("Real physics equations are continuous — positions and velocities evolve smoothly every infinitesimal moment. Computers can't do infinitesimal, so we approximate: we take tiny discrete steps and pretend the world is constant within each step.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)


                        VStack(alignment: .leading, spacing: 8) {
                            Label("The Problem with Standard (Explicit) Euler", systemImage: "xmark.circle.fill")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.red)
                            Text("Standard Euler updates both position and velocity using old (pre-step) values:")
                                .font(.caption).foregroundStyle(AppTheme.secondaryText)
                            OrbitalEquationCard(lines: [
                                "Standard Euler:",
                                "  v_new = v_old + a_old × dt",
                                "  x_new = x_old + v_old × dt   ← old v!",
                                "",
                                "Problem: position doesn't know about the",
                                "velocity update that just happened.",
                                "Result: orbit slowly spirals OUTWARD.",
                                "Energy is not conserved — it grows."
                            ])
                        }


                        VStack(alignment: .leading, spacing: 8) {
                            Label("The Fix: One Small Change", systemImage: "checkmark.circle.fill")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.teal)
                            Text("Semi-Implicit (Symplectic) Euler uses the NEW velocity for the position update:")
                                .font(.caption).foregroundStyle(AppTheme.secondaryText)
                            OrbitalEquationCard(lines: [
                                "Symplectic Euler:",
                                "  v_new = v_old + a_old × dt",
                                "  x_new = x_old + v_new × dt   ← new v!",
                                "",
                                "This tiny change makes it symplectic:",
                                "it preserves a 'shadow' energy that stays",
                                "constant. Orbits don't spiral in or out.",
                                "Energy may oscillate but doesn't drift."
                            ])
                        }

                        OrbitalCallout(text: "Symplectic = structure-preserving. The integrator respects the geometry of Hamiltonian physics.", color: .teal)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Step-by-Step Walkthrough", systemImage: "list.number")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.teal)
                            OrbitalStepCard(steps: [
                                ("1", "Compute acceleration", "a = -GM/r³ × r_vec\nThis is Newton's gravity at the current position."),
                                ("2", "Update velocity", "v += a × dt\nVelocity changes due to gravitational acceleration."),
                                ("3", "Update position with NEW v", "x += v × dt\nUsing the just-updated v — this is what makes it symplectic."),
                                ("4", "Repeat every substep", "We do 8 substeps per frame at dt=0.005 each.\nSmaller dt = more accurate but slower.")
                            ])
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Label("When to Use It", systemImage: "checkmark.seal")
                                .font(.subheadline).fontWeight(.semibold).foregroundStyle(.teal)
                            OrbitalBullet(color: .teal, text: "Long simulations where energy conservation matters (orbits shouldn't decay)")
                            OrbitalBullet(color: .teal, text: "Simple, fast — only one force evaluation per step")
                            OrbitalBullet(color: .red, text: "Not ideal for very high accuracy — it's only 1st-order in position error")
                        }
                    }
                }




                OrbitalLearnSection(
                    number: 7,
                    title: "Velocity Verlet — Deep Dive",
                    icon: "chart.xyaxis.line",
                    color: .green,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 16) {

                        Text("Velocity Verlet is a more sophisticated integrator that uses information from both the beginning and end of each step to update velocity. It's 2nd-order accurate — meaning halving dt cuts the error by 4×, not 2×.")
                            .font(.body).foregroundStyle(AppTheme.primaryText)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("The Three Steps", systemImage: "3.circle.fill")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.green)
                            OrbitalEquationCard(lines: [
                                "Step 1 — Update position:",
                                "  x_new = x + v·dt + ½·a·dt²",
                                "  (Taylor expansion to 2nd order)",
                                "",
                                "Step 2 — Compute new acceleration:",
                                "  a_new = -GM/r_new³ × r_new_vec",
                                "  (Force at the NEW position)",
                                "",
                                "Step 3 — Average the accelerations:",
                                "  v_new = v + ½·(a_old + a_new)·dt",
                                "  (Best estimate of average force)"
                            ])
                        }

                        OrbitalCallout(text: "The key insight: velocity uses the average force over the step, not just the force at the start.", color: .green)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Why the Average Works Better", systemImage: "scale.3d")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.green)
                            Text("Gravity changes continuously as position changes. Over a step, the force at the START is different from the force at the END. By averaging them, Velocity Verlet accounts for the fact that the satellite experienced a range of forces during the step — not just the force it felt at the beginning.")
                                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Step-by-Step Walkthrough", systemImage: "list.number")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.green)
                            OrbitalStepCard(steps: [
                                ("1", "Move position (2nd order)", "x += v·dt + ½·a·dt²\nThe ½·a·dt² term captures curvature — position knows about acceleration, not just velocity."),
                                ("2", "Recompute gravity at new spot", "a_new = -GM / r_new³ × r_new_vec\nNow we know the force at the end of the step."),
                                ("3", "Average forces for velocity", "v += ½·(a_old + a_new)·dt\nThis average is what makes it 2nd-order and time-reversible.")
                            ])
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Time Reversibility", systemImage: "arrow.left.arrow.right")
                                .font(.subheadline).fontWeight(.bold).foregroundStyle(.green)
                            Text("If you negate all velocities and run Velocity Verlet backwards, you get exactly the same trajectory in reverse. This is a deep property that standard Euler completely lacks — it reflects the fact that Newton's laws are time-symmetric.")
                                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Label("Symplectic Euler vs Velocity Verlet", systemImage: "arrow.left.and.right")
                                .font(.subheadline).fontWeight(.semibold).foregroundStyle(.white)
                            OrbitalEquationCard(lines: [
                                "Semi-Implicit Euler:",
                                "  • 1 force evaluation per step",
                                "  • 1st-order position accuracy",
                                "  • Symplectic (conserves shadow energy)",
                                "  • Fast, good for long runs",
                                "",
                                "Velocity Verlet:",
                                "  • 2 force evaluations per step",
                                "  • 2nd-order accuracy",
                                "  • Time-reversible + symplectic",
                                "  • Better for high-precision orbits"
                            ])
                        }

                        OrbitalCallout(text: "Try it: switch integrators in the sim and watch the Total Energy graph — Velocity Verlet stays flatter.", color: .green)
                    }
                }




                OrbitalLearnSection(
                    number: 8,
                    title: "Experiments to Try",
                    icon: "flask.fill",
                    color: .pink,
                    badge: nil,
                    expandedSection: $expandedSection
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        OrbitalExperimentCard(
                            title: "Perfect Circle",
                            steps: ["Set angle to 90°", "Set speed to exactly the Circular hint value", "Press Play"],
                            result: "Watch Total Energy stay perfectly constant. The orbit is a circle.",
                            color: .cyan
                        )
                        OrbitalExperimentCard(
                            title: "Ellipse from Near-Circular",
                            steps: ["Start with circular settings", "Increase speed by 20–40%", "Press Play"],
                            result: "The orbit stretches into an ellipse. The extra energy raises the far side (apoapsis).",
                            color: .green
                        )
                        OrbitalExperimentCard(
                            title: "Crash Landing",
                            steps: ["Reduce speed well below circular", "Press Play"],
                            result: "Not enough tangential speed — gravity wins and the satellite crashes into the planet.",
                            color: .red
                        )
                        OrbitalExperimentCard(
                            title: "Escape Trajectory",
                            steps: ["Set speed above the Escape hint value", "Press Play"],
                            result: "Total energy turns positive. The satellite flies away on a hyperbolic arc.",
                            color: .orange
                        )
                        OrbitalExperimentCard(
                            title: "Integrator Energy Drift",
                            steps: ["Run a long elliptical orbit on Semi-Implicit Euler", "Note the Total E graph", "Switch to Velocity Verlet and reset", "Compare the graphs"],
                            result: "Velocity Verlet should show less energy drift, especially for elongated ellipses.",
                            color: .teal
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

struct OrbitalChangeCard: View {
    let change: OrbitalParameterChange
    @State private var expanded = true

    var paramColor: Color {
        switch change.parameter {
        case .speed: return .green
        case .angle: return .yellow
        case .altitude: return .purple
        case .mass: return .orange
        case .preset: return .blue
        case .integrator: return .teal
        }
    }

    var paramIcon: String {
        switch change.parameter {
        case .speed: return "speedometer"
        case .angle: return "angle"
        case .altitude: return "ruler"
        case .mass: return "globe"
        case .preset: return "star.fill"
        case .integrator: return "function"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } }) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle().fill(paramColor.opacity(0.15)).frame(width: 32, height: 32)
                        Image(systemName: paramIcon)
                            .font(.caption).foregroundStyle(paramColor)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(change.parameter.rawValue)
                            .font(.caption2).fontWeight(.semibold)
                            .foregroundStyle(paramColor)
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
                Divider().background(paramColor.opacity(0.2))
                VStack(alignment: .leading, spacing: 8) {

                    Text(change.physicsExplanation)
                        .font(.caption)
                        .foregroundStyle(AppTheme.primaryText)
                        .fixedSize(horizontal: false, vertical: true)


                    HStack(spacing: 6) {
                        Image(systemName: change.orbitTypeBefore.icon)
                            .font(.caption2)
                        Text(change.orbitTypeBefore.rawValue)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(change.orbitTypeBefore.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(change.orbitTypeBefore.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding(10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(paramColor.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(paramColor.opacity(0.2), lineWidth: 1))
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}

struct OrbitalLiveCard: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        VStack(spacing: 6) {
            OrbitalLiveRow(label: "Orbit Type",        value: viewModel.orbitType.rawValue,                                    color: viewModel.orbitType.color)
            OrbitalLiveRow(label: "Speed  |v|",        value: viewModel.speedDisplay,                                          color: .green)
            OrbitalLiveRow(label: "Circular Speed",    value: viewModel.circularDisplay,                                       color: .cyan)
            OrbitalLiveRow(label: "Escape Speed",      value: viewModel.escapeDisplay,                                         color: .orange)
            OrbitalLiveRow(label: "Surface Esc. Speed",value: viewModel.surfaceEscapeDisplay,                                  color: .red)
            OrbitalLiveRow(label: "Altitude",          value: viewModel.altitudeDisplay,                                       color: .purple)
            OrbitalLiveRow(label: "Radius from centre",value: viewModel.radiusDisplay,                                         color: .indigo)
            OrbitalLiveRow(label: "KE  (km²/s²)",      value: String(format: "%.2f", viewModel.kineticEnergyReal),             color: .orange)
            OrbitalLiveRow(label: "PE  (km²/s²)",      value: String(format: "%.2f", viewModel.potentialEnergyReal),           color: .blue)
            OrbitalLiveRow(label: "Total E  (km²/s²)", value: String(format: "%.2f", viewModel.totalEnergyReal),               color: .cyan)
        }
    }
}

struct OrbitalLiveRow: View {
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

struct OrbitalLearnSection<Content: View>: View {
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

struct OrbitalCallout: View {
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

struct OrbitalEquationCard: View {
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

struct OrbitalBullet: View {
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

struct OrbitalInsightRow: View {
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

struct OrbitalEnergyTable: View {
    var body: some View {
        VStack(spacing: 1) {
            OrbitalTableRow(e: "E < 0", type: "Elliptical (Bound)",   detail: "Total energy negative → satellite cannot escape", color: .cyan)
            OrbitalTableRow(e: "E ≈ 0", type: "Parabolic",            detail: "Zero total energy → barely reaches infinity",     color: .yellow)
            OrbitalTableRow(e: "E > 0", type: "Hyperbolic (Escape)",  detail: "Positive total energy → escapes with speed left", color: .orange)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8)).clipped()
    }
}

struct OrbitalTableRow: View {
    let e: String
    let type: String
    let detail: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(e)
                    .font(.system(.subheadline, design: .monospaced)).fontWeight(.bold)
                    .foregroundStyle(color).frame(width: 60, alignment: .leading)
                Text("→  \(type)")
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
            }
            Text(detail)
                .font(.caption).foregroundStyle(AppTheme.secondaryText)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.07))
    }
}

struct OrbitalStepCard: View {
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

struct OrbitalExperimentCard: View {
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
