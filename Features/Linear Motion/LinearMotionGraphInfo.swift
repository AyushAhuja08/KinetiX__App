

import SwiftUI

struct LinearMotionGraphInfoSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Key Concepts", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(.purple)

                        ConceptCard(
                            title: "Understanding Velocity",
                            icon: "arrow.right.circle.fill",
                            color: .blue,
                            points: [
                                "Rate of change of position: v = ds/dt",
                                "Has direction indicated by sign",
                                "Positive: moving right/forward",
                                "Negative: moving left/backward",
                                "Zero: instantaneous stop",
                                "Can be constant (a=0) or changing (a≠0)"
                            ]
                        )

                        ConceptCard(
                            title: "Velocity & Acceleration",
                            icon: "gauge.with.dots.needle.67percent",
                            color: .green,
                            points: [
                                "Acceleration: rate of change of velocity (a = dv/dt)",
                                "Same sign → speed increases",
                                "Opposite signs → speed decreases",
                                "Example: v = +5 m/s, a = -2 m/s² means slowing while moving forward"
                            ]
                        )
                    }

                    //Graph Readibility
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Reading the Graphs", systemImage: "chart.xyaxis.line")
                            .font(.headline)
                            .foregroundStyle(.indigo)

                        LearnGraphCard(title: "Distance–Time (s–t)", points: [
                            "Slope = velocity",
                            "Positive acceleration → curve steepens",
                            "Negative acceleration → curve flattens"
                        ])

                        LearnGraphCard(title: "Velocity–Time (v–t)", points: [
                            "Slope = acceleration",
                            "Flat line → constant velocity (a=0)",
                            "Area under curve = distance change"
                        ])

                        LearnGraphCard(title: "Acceleration–Time (a–t)", points: [
                            "Flat line → constant acceleration",
                            "Above zero → speeding up",
                            "Below zero → slowing down"
                        ])
                    }


                    VStack(alignment: .leading, spacing: 12) {
                        Label("Physics Formulas", systemImage: "function")
                            .font(.headline)
                            .foregroundStyle(.red)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Kinematic Equations")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.bottom, 2)

                            EquationRow(equation: "v(t) = v₀ + at")
                            EquationRow(equation: "s(t) = s₀ + v₀t + ½at²")
                            EquationRow(equation: "v² = v₀² + 2a(s - s₀)")
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Variables")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("v₀ = initial velocity, a = acceleration, t = time, s = distance")
                                .font(.subheadline)
                                .foregroundStyle(.primary.opacity(0.85))
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Graph Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
