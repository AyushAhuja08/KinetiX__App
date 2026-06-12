
import SwiftUI

struct ProjectileMotionGraphInfoSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Understanding Vectors", systemImage: "arrow.triangle.branch")
                            .font(.headline)
                            .foregroundStyle(.purple)

                        ConceptCard(
                            title: "Velocity Vectors",
                            icon: "arrow.right.circle.fill",
                            color: .red,
                            points: [
                                "Velocity has magnitude (speed) and direction",
                                "v (RED) points in direction of motion",
                                "vx (BLUE) stays constant during flight",
                                "vy (GREEN) changes due to gravity",
                                "|v| = sqrt(vx^2 + vy^2) gives actual speed",
                                "Toggle vectors in simulation"
                            ]
                        )

                        ConceptCard(
                            title: "Vector Decomposition",
                            icon: "arrow.up.left.and.arrow.down.right",
                            color: .blue,
                            points: [
                                "vx = v x cos(theta) at launch",
                                "vy = v x sin(theta) at launch",
                                "Components are INDEPENDENT",
                                "vx remains constant",
                                "vy(t) = vy0 - g*t"
                            ]
                        )

                        ConceptCard(
                            title: "Velocity Through Flight",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green,
                            points: [
                                "Launch: max velocity, angled up",
                                "Rising: vy decreases, vx constant",
                                "Apex: vy = 0 (horizontal only)",
                                "Falling: vy negative (downward)",
                                "Landing: speed equals launch speed",
                                "Angle changes throughout flight"
                            ]
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Reading the Graphs", systemImage: "chart.xyaxis.line")
                            .font(.headline)
                            .foregroundStyle(.indigo)

                        LearnGraphCard(title: "Trajectory (x-y)", points: [
                            "Shows 2D flight path",
                            "Parabolic curve with constant gravity",
                            "Changes create new future path"
                        ])

                        LearnGraphCard(title: "x vs Time", points: [
                            "Approximately linear (no horizontal acceleration)",
                            "Slope = vx (constant)"
                        ])

                        LearnGraphCard(title: "y vs Time", points: [
                            "Curved due to gravity",
                            "Slope = vy (changes with time)",
                            "Peak when vy(t) = 0"
                        ])
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Physics Formulas", systemImage: "function")
                            .font(.headline)
                            .foregroundStyle(.red)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Velocity Components")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.bottom, 2)

                            EquationRow(equation: "vx = v0 x cos(theta)")
                            EquationRow(equation: "vy(t) = v0 x sin(theta) - g*t")
                            EquationRow(equation: "|v| = sqrt(vx^2 + vy^2)")
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Position")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.bottom, 2)

                            EquationRow(equation: "x(t) = vx x t")
                            EquationRow(equation: "y(t) = vy0 x t - 0.5g*t^2")
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Special Points")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.bottom, 2)

                            EquationRow(equation: "Range R = v0^2 sin(2theta) / g")
                            EquationRow(equation: "Max height H = v0^2 sin^2(theta) / (2g)")
                            EquationRow(equation: "Flight time T = 2v0 sin(theta) / g")
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Variables")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("v0 = initial speed, theta = launch angle, g = gravity (9.8 m/s^2)")
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
