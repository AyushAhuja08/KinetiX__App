

import SwiftUI

struct EscapeVelocityVisualizeView: View {
    var viewModel: EscapeVelocityViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitledCard(
                    title: "Simulation",
                    description: "Select a celestial body (Earth, Moon, or Mars) and watch the orbit. Use the speed slider and buttons below to see whether the object stays in orbit, escapes, or falls back."
                ) {
                    EscapeVelocityAnimationTabView(viewModel: viewModel)
                }

                // Horizontal swipable row for secondary cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Speed vs Escape Velocity",
                            description: "Compare your current speed to the escape velocity for the selected body. If your speed is above escape velocity, the object will leave the gravitational pull."
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Status: \(viewModel.stateDescription)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(viewModel.stateColor)
                                    Spacer()
                                }
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Your Speed")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text(String(format: "%.2f km/s", viewModel.bodySpeed))
                                            .font(.title2).fontWeight(.bold).foregroundStyle(.blue)
                                    }
                                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Escape Velocity")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text(String(format: "%.1f km/s", viewModel.surfaceEscapeVelocity))
                                            .font(.title2).fontWeight(.bold).foregroundStyle(.red)
                                    }
                                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "Graphs",
                            description: "Switch between Altitude, Velocity, and Distance from Center. The graph updates as the simulation runs."
                        ) {
                            EscapeVelocityGraphsView(viewModel: viewModel)
                                .accessibilityElement()
                                .accessibilityLabel(viewModel.graphAccessibilityLabel)
                                .accessibilityAddTraits(.updatesFrequently)
                                .accessibilityHint("Double-tap to hear current speed vs escape velocity comparison.")
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16) // Allows scrolling edge-to-edge
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct EscapeVelocityAnimationTabView: View {
    var viewModel: EscapeVelocityViewModel

    var body: some View {
        VStack(spacing: 0) {

            VStack(spacing: 12) {

                HStack(spacing: 12) {
                    ForEach(CelestialBody.allCases, id: \.self) { body in
                        Button(action: {
                            viewModel.selectedBody = body
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: body.icon)
                                    .font(.title2)
                                Text(body.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                viewModel.selectedBody == body ?
                                body.color.opacity(0.2) :
                                Color.gray.opacity(0.1)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        viewModel.selectedBody == body ?
                                        body.color :
                                        Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .padding(.top, 8)


                HStack {
                    Image(systemName: statusIcon)
                        .foregroundStyle(viewModel.stateColor)
                        .font(.title2)
                    Text(viewModel.stateDescription)
                        .font(.headline)
                        .foregroundStyle(viewModel.stateColor)
                    Spacer()
                }


                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Speed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.2f km/s", viewModel.bodySpeed))
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }

                        Divider()
                            .frame(height: 30)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Altitude")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f km", viewModel.altitude))
                                .font(.headline)
                                .foregroundStyle(.green)
                        }

                        Spacer()
                    }


                    HStack(spacing: 12) {

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "speedometer")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                Text("Your Speed")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            Text(String(format: "%.1f km/s", viewModel.bodySpeed))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))


                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                Text("Escape Velocity")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            Text(String(format: "%.1f km/s", viewModel.surfaceEscapeVelocity))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }


                InsightStripView(insight: viewModel.currentInsight)
                    .padding(.horizontal)
            }
            .padding(.bottom, 8)
            .background(Color(.systemGray6))


            GeometryReader { geometry in
                ZStack {

                    Color(.systemBackground)

                    let centerX = geometry.size.width / 2

                    let centerY = geometry.size.height / 2 + 20

                    let maxSafeRadius = min(geometry.size.width / 2 - 20, centerY - 20, geometry.size.height - centerY - 20)

                    let safeOrbitRadius = min(viewModel.orbitRadius, maxSafeRadius)


                    ForEach([80.0, 120.0, 160.0].filter { $0 < maxSafeRadius }, id: \.self) { radius in
                        Circle()
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            .frame(width: radius * 2, height: radius * 2)
                            .position(x: centerX, y: centerY)
                    }


                    Circle()
                        .stroke(viewModel.stateColor.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .frame(width: safeOrbitRadius * 2, height: safeOrbitRadius * 2)
                        .position(x: centerX, y: centerY)


                    ZStack {

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [viewModel.planetColor, viewModel.planetSecondaryColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: viewModel.planetRadius * 2, height: viewModel.planetRadius * 2)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )


                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: viewModel.planetRadius * 1.5, height: viewModel.planetRadius * 1.5)
                            .offset(x: -viewModel.planetRadius * 0.3, y: -viewModel.planetRadius * 0.3)


                        Text(viewModel.selectedBody.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .offset(y: viewModel.planetRadius * 0.3)
                    }
                    .position(x: centerX, y: centerY)


                    let bodyX = centerX + safeOrbitRadius * CGFloat(cos(viewModel.currentAngle))
                    let bodyY = centerY + safeOrbitRadius * CGFloat(sin(viewModel.currentAngle))

                    ZStack {

                        Circle()
                            .fill(viewModel.stateColor)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .position(x: bodyX, y: bodyY)
                    .accessibilityElement()
                    .accessibilityLabel(viewModel.simulationBodyAccessibilityLabel)
                    .accessibilityAddTraits(.updatesFrequently)

                }
            }
            .frame(height: 300)
            .background(Color(.systemBackground))


            if viewModel.hasEscaped {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        Text("🚀 Escaped \(viewModel.selectedBody.rawValue)!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    Text("Speed ≥ Escape Velocity")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            } else if viewModel.hasReachedPlanet {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundStyle(.orange)
                        Text("💥 Fell to \(viewModel.selectedBody.rawValue)!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                    Text("Speed < Escape Velocity")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }


            VStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Body Speed", systemImage: "speedometer")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(String(format: "%.2f km/s", viewModel.bodySpeed))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    }

                    Slider(value: Binding(
                        get: { viewModel.bodySpeed },
                        set: { viewModel.setBodySpeed($0) }
                    ), in: 1.0...15.0, step: 0.1)
                    .tint(viewModel.stateColor)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { _ in Haptics.sliderEnd() }
                    )


                    HStack {
                        Text("1 km/s")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        VStack(spacing: 2) {
                            Text(String(format: "%@ Escape: %.1f km/s", viewModel.selectedBody.rawValue, viewModel.surfaceEscapeVelocity))
                                .font(.caption2)
                                .foregroundStyle(.blue)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Text("15 km/s")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))


                HStack(spacing: 24) {
                    Button(action: {
                        Haptics.playPause()
                        viewModel.playPause()
                    }) {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.blue)
                    }

                    Button(action: {
                        Haptics.reset()
                        viewModel.reset()
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.orange)
                    }

                    Spacer()
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
        }
    }

    private var statusIcon: String {
        switch viewModel.orbitalState {
        case .stable:
            return "checkmark.circle.fill"
        case .escaping:
            return "arrow.up.circle.fill"
        case .decaying:
            return "arrow.down.circle.fill"
        }
    }
}
