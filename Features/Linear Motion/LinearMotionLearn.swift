

import SwiftUI

struct LinearMotionLearnView: View {
    var viewModel: LinearMotionViewModel
    @State private var showAllChanges = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                KeyInsightBanner(
                    insight: "Linear motion is the foundation of all physics. Master this, and you'll understand how everything moves!",
                    icon: "star.fill",
                    color: .blue
                )

                //Basic Information
                ConceptExplanationCard(
                    title: "What is Linear Motion?",
                    icon: "arrow.right.circle.fill",
                    color: .indigo,
                    explanation: "Linear motion is movement along a straight line. It's the simplest form of motion, where an object's position changes in one dimension over time. Think of a car driving on a straight highway or a ball rolling in a single direction.",
                    expandablePoints: [
                        "Position (s): Where the object is located at any moment",
                        "Velocity (v): How fast the position is changing - the rate of motion",
                        "Acceleration (a): How fast the velocity is changing - the rate of change of rate of motion",
                        "These three quantities are connected through calculus: velocity is the derivative of position, and acceleration is the derivative of velocity"
                    ]
                )


                LearnHeroCard(
                    title: "Live Values",
                    icon: "waveform.path.ecg",
                    color: .blue
                ) {
                    VStack(spacing: 12) {
                        LearnValueRow(label: "Time", value: String(format: "%.2f s", viewModel.currentTime), icon: "clock", color: .blue)
                        LearnValueRow(label: "Distance s(t)", value: String(format: "%.2f m", viewModel.currentDistance), icon: "arrow.right", color: .green)
                        LearnValueRow(label: "Velocity v(t)", value: String(format: "%.2f m/s", viewModel.currentVelocity), icon: "speedometer", color: .orange)
                        LearnValueRow(label: "Acceleration a(t)", value: String(format: "%.2f m/s²", viewModel.currentAcceleration), icon: "gauge.high", color: .red)
                    }
                    Text("Values at the current time cursor (red line)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }


                PhysicsChangesSection(
                    title: viewModel.changeEvents.isEmpty ? "Your Changes (none yet)" : "Your Changes (\(viewModel.changeEvents.count))",
                    badge: viewModel.changeEvents.isEmpty ? nil : "\(viewModel.changeEvents.count)",
                    isEmpty: viewModel.changeEvents.isEmpty,
                    emptyPrompt: "Adjust any slider on the Visualize tab. Each change will appear here with a full physics explanation.",
                    onClear: { viewModel.changeEvents.removeAll() }
                ) {
                    let displayedEvents = showAllChanges ? viewModel.changeEvents.reversed() : Array(viewModel.changeEvents.reversed().prefix(3))
                    
                    VStack(spacing: 10) {
                        ForEach(displayedEvents) { event in
                            PhysicsChangeCard(
                                parameter: event.changedParameter,
                                headline: event.headline,
                                explanation: event.physicsExplanation,
                                icon: event.paramIcon,
                                color: event.paramColor,
                                timestamp: String(format: "t = %.2f s", event.time)
                            )
                        }
                        
                        if viewModel.changeEvents.count > 3 {
                            Button(action: {
                                withAnimation {
                                    showAllChanges.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(showAllChanges ? "See Less" : "See All (\(viewModel.changeEvents.count))")
                                    Image(systemName: showAllChanges ? "chevron.up" : "chevron.down")
                                }
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(AppTheme.primaryAccent)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }


                GraphInterpretationCard(
                    title: "Reading the Graphs",
                    icon: "chart.xyaxis.line",
                    color: .cyan,
                    graphName: "position-time",
                    interpretations: [
                        (aspect: "Positive slope", meaning: "Object moving forward (positive velocity)"),
                        (aspect: "Negative slope", meaning: "Object moving backward (negative velocity)"),
                        (aspect: "Steeper slope", meaning: "Faster speed - velocity has greater magnitude"),
                        (aspect: "Horizontal line", meaning: "Object is stationary (zero velocity)"),
                        (aspect: "Curved line", meaning: "Velocity is changing - acceleration is present")
                    ]
                )


                StepByStepCard(
                    title: "Calculus Connection: How the Graphs Relate",
                    icon: "infinity",
                    color: .mint,
                    steps: [
                        (phase: "Position → Velocity", description: "The slope of the position graph gives you velocity. Steep upward = fast forward. Steep downward = fast backward."),
                        (phase: "Velocity → Acceleration", description: "The slope of the velocity graph gives you acceleration. Upward slope = speeding up. Downward slope = slowing down."),
                        (phase: "Velocity → Displacement", description: "The area under the velocity graph gives you total displacement. Positive area = net forward motion."),
                        (phase: "Acceleration → Velocity Change", description: "The area under the acceleration graph gives you how much velocity changed. This is the integral relationship.")
                    ]
                )


                MisconceptionCard(
                    title: "Common Misconceptions",
                    icon: "exclamationmark.triangle.fill",
                    color: .red,
                    misconceptions: [
                        (
                            myth: "Negative acceleration always means slowing down",
                            reality: "Negative acceleration means acceleration in the negative direction. If you're moving backward (negative velocity), negative acceleration actually speeds you up in that direction!"
                        ),
                        (
                            myth: "Zero acceleration means the object isn't moving",
                            reality: "Zero acceleration means velocity isn't changing. The object could be moving at constant velocity! Think of cruise control in a car."
                        ),
                        (
                            myth: "Velocity and speed are the same thing",
                            reality: "Velocity includes direction (positive or negative), while speed is just the magnitude. An object moving backward at 10 m/s has velocity -10 m/s but speed 10 m/s."
                        )
                    ]
                )


                InteractiveQuestionCard(
                    title: "Test Your Understanding",
                    icon: "questionmark.circle.fill",
                    color: .purple,
                    questions: [
                        QA(
                            question: "If position vs time graph is a straight line, what can you say about acceleration?",
                            answer: "Acceleration must be zero! A straight line means constant velocity, and constant velocity means no acceleration."
                        ),
                        QA(
                            question: "Can an object have velocity in one direction and acceleration in the opposite direction?",
                            answer: "Yes! This is exactly what happens when you're slowing down. For example, moving forward (positive velocity) while braking (negative acceleration)."
                        ),
                        QA(
                            question: "What does it mean when velocity graph crosses the time axis?",
                            answer: "The object changes direction! It stops momentarily (zero velocity) and then starts moving in the opposite direction."
                        )
                    ]
                )


                LearnEquationCard(
                    title: "The Equations",
                    icon: "function",
                    color: .purple,
                    equations: [
                        "s(t) = s₀ + v₀t + ½at²",
                        "v(t) = v₀ + at",
                        "a(t) = constant"
                    ]
                )


                LearnDetailedExamplesCard(
                    title: "Real-World Examples",
                    icon: "car.fill",
                    color: .orange,
                    examples: [
                        ("car", "Car accelerating from rest", "v₀ = 0, a > 0"),
                        ("brake.signal", "Car braking", "v₀ > 0, a < 0"),
                        ("arrow.up.circle", "Object thrown upward", "v₀ > 0, a = -9.8 m/s²"),
                        ("building.2", "Elevator", "Complex velocity profile"),
                        ("sparkles", "Rocket launch", "Increasing acceleration")
                    ]
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct LearnHeroCard<Content: View>: View {
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnValueRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
                .frame(width: 28)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct LearnChangeSummaryCard<Content: View>: View {
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
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnChangeHistoryCard<Content: View>: View {
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
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnConceptCard: View {
    let title: String
    let icon: String
    let color: Color
    let concepts: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(concepts.enumerated()), id: \.offset) { _, concept in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(color)
                            .frame(width: 8, height: 8)
                            .padding(.top, 6)
                        Text(concept)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnEquationCard: View {
    let title: String
    let icon: String
    let color: Color
    let equations: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(equations.enumerated()), id: \.offset) { _, equation in
                    Text(equation)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.1))
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

struct LearnDetailedExamplesCard: View {
    let title: String
    let icon: String
    let color: Color
    let examples: [(String, String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(examples.enumerated()), id: \.offset) { _, example in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: example.0)
                            .foregroundStyle(color)
                            .font(.title3)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(example.1)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            Text(example.2)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}
