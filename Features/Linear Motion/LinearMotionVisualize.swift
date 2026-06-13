

import SwiftUI

struct LinearMotionVisualizeView: View {
    var viewModel: LinearMotionViewModel
    @State private var showingGraphInfo = false
    @State private var showingHelp = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitledCard(
                    title: "Simulation",
                    description: "Watch the object move along the track. Use the buttons below to play, pause, reset, or tap the info icon for more details."
                ) {
                    LinearMotionSimulationView(viewModel: viewModel, showingGraphInfo: $showingGraphInfo)
                        .frame(height: 180)
                }

                // Horizontal swipable row for Live Values and What's Happening
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Live Values",
                            description: "Current distance, velocity, and acceleration in real time as the simulation runs."
                        ) {
                            LiveValuesPanel(values: viewModel.liveValuesData)
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "What’s Happening?",
                            description: "A short explanation of the current motion state and how the physics applies."
                        ) {
                            let insight = viewModel.enhancedPhysicsInsight
                            PhysicsInsightCard(
                                title: insight.title,
                                icon: insight.icon,
                                color: insight.color,
                                explanation: insight.explanation,
                                formula: insight.formula
                            )
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16) // Allows scrolling edge-to-edge

                // Horizontal swipable row for Graphs and Sliders
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Graphs",
                            description: "See how distance, velocity, and acceleration change over time. The graph updates as the simulation runs."
                        ) {
                            LinearFocusModeGraphView(viewModel: viewModel)
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "Adjust Parameters",
                            description: "Change initial velocity and acceleration here. After you change a value, the simulation and graphs update so you can see how the motion changes."
                        ) {
                            EnhancedLinearControlsView(viewModel: viewModel)
                        }
                        .frame(width: isRegular ? 480 : 310, height: isRegular ? 460 : 390)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16) // Allows scrolling edge-to-edge

                if let lastChange = viewModel.changeEvents.last,
                   viewModel.currentTime - lastChange.time < 1.0 {
                    ChangeImpactView(
                        changeType: lastChange.velocitySettingAfter != nil ? "Initial Velocity" : "Acceleration",
                        icon: lastChange.velocitySettingAfter != nil ? "speedometer" : "arrow.up.arrow.down",
                        beforeValue: String(format: "%.1f m/s", lastChange.velocitySettingBefore ?? lastChange.accelerationBefore ?? 0),
                        afterValue: String(format: "%.1f m/s", lastChange.velocitySettingAfter ?? lastChange.accelerationAfter ?? 0),
                        impact: lastChange.velocitySettingAfter != nil ?
                            "The object now starts from a different initial velocity. Watch how the distance and velocity graphs shift!" :
                            "The rate of velocity change is modified. Notice how the graph curves change!",
                        color: lastChange.velocitySettingAfter != nil ? .blue : .orange
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .sheet(isPresented: $showingGraphInfo) {
            LinearMotionGraphInfoSheet()
        }
    }
}

struct LinearMotionSimulationView: View {
    var viewModel: LinearMotionViewModel
    @Binding var showingGraphInfo: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time: \(String(format: "%.2f", viewModel.currentTime)) s")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Distance: \(String(format: "%.2f", viewModel.currentDistance)) m")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                Spacer()


                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Direction:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Image(systemName: viewModel.currentVelocity > 0 ? "arrow.right" :
                                         viewModel.currentVelocity < 0 ? "arrow.left" : "circle")
                            .font(.caption)
                            .foregroundStyle(viewModel.currentVelocity > 0 ? Color.green :
                                           viewModel.currentVelocity < 0 ? Color.red : Color.gray)
                    }
                    Text(abs(viewModel.currentVelocity) < 0.1 ? "At Rest" :
                         viewModel.currentVelocity > 0 ? "Forward" : "Backward")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {

                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 6)
                        .clipShape(RoundedRectangle(cornerRadius: 3))


                    ForEach([-25, 0, 25], id: \.self) { distance in
                        VStack(spacing: 2) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 2, height: 12)
                            Text("\(distance)m")
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                        .position(
                            x: geometry.size.width * CGFloat((Double(distance) / 50.0) + 0.5),
                            y: 30
                        )
                    }


                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 2, height: 24)
                        .position(x: geometry.size.width / 2, y: 12)


                    let objectX = viewModel.objectPosition(in: geometry.size.width)


                    if abs(viewModel.currentVelocity) > 0.5 {
                        let arrowLength = min(abs(viewModel.currentVelocity) * 8, 40)
                        Path { path in
                            let startX = objectX
                            let endX = viewModel.currentVelocity > 0 ? startX + arrowLength : startX - arrowLength
                            path.move(to: CGPoint(x: startX, y: 12))
                            path.addLine(to: CGPoint(x: endX, y: 12))
                        }
                        .stroke(Color.green, lineWidth: 2)


                        Path { path in
                            let endX = viewModel.currentVelocity > 0 ? objectX + arrowLength : objectX - arrowLength
                            if viewModel.currentVelocity > 0 {
                                path.move(to: CGPoint(x: endX - 6, y: 8))
                                path.addLine(to: CGPoint(x: endX, y: 12))
                                path.addLine(to: CGPoint(x: endX - 6, y: 16))
                            } else {
                                path.move(to: CGPoint(x: endX + 6, y: 8))
                                path.addLine(to: CGPoint(x: endX, y: 12))
                                path.addLine(to: CGPoint(x: endX + 6, y: 16))
                            }
                        }
                        .stroke(Color.green, lineWidth: 2)
                    }


                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                        .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                        .position(x: objectX, y: 12)
                        .accessibilityElement()
                        .accessibilityLabel(viewModel.simulationBodyAccessibilityLabel)
                        .accessibilityAddTraits(.updatesFrequently)


                    AnnotationLabel(
                        text: "v = \(String(format: "%.1f", viewModel.currentVelocity)) m/s",
                        color: .green,
                        icon: "speedometer"
                    )
                    .position(x: objectX, y: 50)
                }
            }
            .frame(height: 60)

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


                Button(action: {
                    showingGraphInfo = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

