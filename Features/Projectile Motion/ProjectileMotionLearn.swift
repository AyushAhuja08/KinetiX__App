

import SwiftUI

struct ProjectileMotionLearnView: View {
    var viewModel: ProjectileMotionViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                KeyInsightBanner(
                    insight: "Horizontal and vertical motions are completely independent! This is the secret to understanding projectile motion.",
                    icon: "star.fill",
                    color: .orange
                )


                ConceptExplanationCard(
                    title: "What Makes Projectile Motion Special?",
                    icon: "figure.archery",
                    color: .indigo,
                    explanation: "Projectile motion combines two independent motions: constant velocity horizontally and accelerated motion vertically. The key insight is that these two directions don't affect each other! The horizontal motion continues steadily while gravity pulls the object down vertically.",
                    expandablePoints: [
                        "Horizontal: No forces act horizontally (ignoring air resistance), so velocity stays constant",
                        "Vertical: Gravity pulls downward with constant acceleration g ≈ 9.8 m/s²",
                        "The curved trajectory (parabola) emerges from combining these two independent motions",
                        "At the peak of the arc, vertical velocity is zero, but horizontal velocity is unchanged!"
                    ]
                )


                LearnHeroCard(
                    title: "Live Values",
                    icon: "waveform.path.ecg",
                    color: .blue
                ) {
                    let pos = viewModel.currentPosition
                    let vel = viewModel.currentVelocity

                    VStack(spacing: 12) {
                        LearnValueRow(label: "Time", value: String(format: "%.2f s", viewModel.currentTime), icon: "clock", color: .blue)
                        LearnValueRow(label: "x(t)", value: String(format: "%.2f m", pos.x), icon: "arrow.right", color: .green)
                        LearnValueRow(label: "y(t)", value: String(format: "%.2f m", pos.y), icon: "arrow.up", color: .purple)
                        LearnValueRow(label: "Speed", value: String(format: "%.1f m/s", viewModel.speed), icon: "speedometer", color: .orange)
                        LearnValueRow(label: "Angle", value: String(format: "%.0f°", viewModel.angle), icon: "angle", color: .red)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    Text("Velocity Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 4)

                    VStack(spacing: 6) {
                        InfoRow(label: "vₓ(t)", value: String(format: "%.2f m/s", vel.dx))
                        InfoRow(label: "vᵧ(t)", value: String(format: "%.2f m/s", vel.dy))
                        InfoRow(label: "|v(t)|", value: String(format: "%.2f m/s", viewModel.currentSpeedMagnitude))
                        InfoRow(label: "Gravity", value: String(format: "%.1f m/s²", viewModel.gravity))
                    }

                    Text("Current position and velocity components")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }


                PhysicsChangesSection(
                    title: viewModel.changeEvents.isEmpty ? "Your Changes (none yet)" : "Your Changes (\(viewModel.changeEvents.count))",
                    badge: viewModel.changeEvents.isEmpty ? nil : "\(viewModel.changeEvents.count)",
                    isEmpty: viewModel.changeEvents.isEmpty,
                    emptyPrompt: "Start the simulation and adjust launch speed or angle. Each change will appear here with a full physics explanation.",
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


                StepByStepCard(
                    title: "Trajectory Phases: What Happens When",
                    icon: "arrow.up.and.down.circle.fill",
                    color: .blue,
                    steps: [
                        (phase: "Launch", description: "Initial velocity splits into horizontal (vₓ = v₀cos θ) and vertical (vᵧ = v₀sin θ) components. Both start at maximum."),
                        (phase: "Ascent", description: "Gravity slows vertical velocity while horizontal velocity stays constant. The object rises and moves forward."),
                        (phase: "Peak", description: "Vertical velocity reaches zero! But horizontal velocity is still the same. This is the highest point."),
                        (phase: "Descent", description: "Vertical velocity becomes negative (downward). Gravity accelerates it downward. Horizontal velocity unchanged."),
                        (phase: "Landing", description: "Object returns to initial height with same speed as launch, but velocity is now angled downward.")
                    ]
                )


                ConceptExplanationCard(
                    title: "Angle and Range: The 45° Sweet Spot",
                    icon: "angle",
                    color: .green,
                    explanation: "For maximum range on level ground, launch at 45°! This perfectly balances time in air (vertical) with horizontal distance. Complementary angles (like 30° and 60°) give the same range because they balance height vs. time differently but achieve the same result.",
                    expandablePoints: [
                        "45° gives maximum range: R = v₀²/g",
                        "Angles below 45° trade height for more horizontal emphasis",
                        "Angles above 45° trade range for more height",
                        "30° and 60° both give the same range (symmetry around 45°)",
                        "90° (straight up) gives zero range but maximum height"
                    ]
                )


                MisconceptionCard(
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    misconceptions: [
                        (
                            myth: "At the peak, the projectile stops completely",
                            reality: "Only the vertical velocity is zero at the peak! The horizontal velocity continues unchanged. The object is still moving forward at constant speed."
                        ),
                        (
                            myth: "Horizontal velocity changes during flight",
                            reality: "With no air resistance, horizontal velocity stays perfectly constant throughout the entire flight. Only the vertical component changes due to gravity."
                        ),
                        (
                            myth: "A heavier object will travel farther when thrown",
                            reality: "Mass doesn't affect trajectory! Both heavy and light objects follow the same path when launched with the same velocity and angle (ignoring air resistance)."
                        )
                    ]
                )


                InteractiveQuestionCard(
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    questions: [
                        QA(
                            question: "You throw a ball horizontally from a cliff. At the same instant, you drop another ball. Which hits the ground first?",
                            answer: "They hit at the same time! Both start with zero vertical velocity and experience the same downward acceleration. The horizontal motion of the thrown ball doesn't affect its vertical fall."
                        ),
                        QA(
                            question: "If you double the launch speed, how does the range change?",
                            answer: "Range quadruples! Since R = v₀²sin(2θ)/g, doubling v₀ means (2v₀)² = 4v₀², so the range becomes 4 times larger."
                        ),
                        QA(
                            question: "At what point in the trajectory is the speed minimum?",
                            answer: "At the peak! The vertical component is zero there, so the speed equals just the horizontal component, which is the minimum speed during flight."
                        )
                    ]
                )


                LearnConceptCard(
                    title: "Vector Decomposition Deep Dive",
                    icon: "arrow.up.right.and.arrow.down.left",
                    color: .mint,
                    concepts: [
                        "Any 2D velocity can be split into perpendicular components",
                        "vₓ = v cos(θ): Projects velocity onto horizontal axis",
                        "vᵧ = v sin(θ): Projects velocity onto vertical axis",
                        "These components evolve independently over time",
                        "Recombine using Pythagorean theorem: v = √(vₓ² + vᵧ²)"
                    ]
                )


                LearnEquationCard(
                    title: "The Equations",
                    icon: "function",
                    color: .purple,
                    equations: [
                        "x(t) = v₀ cos(θ) · t",
                        "y(t) = v₀ sin(θ) · t - ½gt²",
                        "Range = v₀² sin(2θ) / g",
                        "Peak Height = (v₀ sin(θ))² / (2g)"
                    ]
                )


                LearnDetailedExamplesCard(
                    title: "Real-World Examples",
                    icon: "globe",
                    color: .orange,
                    examples: [
                        ("basketball.fill", "Sports", "Basketball, soccer trajectories"),
                        ("target", "Ballistics and targeting", "Military and artillery calculations"),
                        ("airplane", "Rocket trajectories", "Space launch and orbital mechanics"),
                        ("sparkles", "Planetary orbits", "Understanding celestial motion"),
                        ("water.waves", "Water fountains", "Arc design and optimization")
                    ]
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}
