

import SwiftUI

struct ProjectileMotionVisualizeView: View {
    var viewModel: ProjectileMotionViewModel
    @State private var showingGraphInfo = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitledCard(
                    title: "Simulation",
                    description: "Watch the projectile follow its parabolic path. Use the buttons below to play, pause, reset, or tap the info icon for more details."
                ) {
                    ProjectileSimulationView(viewModel: viewModel, showingGraphInfo: $showingGraphInfo)
                        .frame(height: 320)
                }

                // Horizontal swipable row for Live Values and What's Happening
                if isRegular {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Live Values",
                            description: "Current horizontal and vertical position, velocity components, and speed in real time."
                        ) {
                            LiveValuesPanel(values: viewModel.liveValuesData)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "What’s Happening?",
                            description: "A short explanation of the current flight phase and how the physics applies."
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
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            TitledCard(
                                title: "Live Values",
                                description: "Current horizontal and vertical position, velocity components, and speed in real time."
                            ) {
                                LiveValuesPanel(values: viewModel.liveValuesData)
                            }
                            .frame(width: 310, height: isRegular ? 460 : 390)

                            TitledCard(
                                title: "What’s Happening?",
                                description: "A short explanation of the current flight phase and how the physics applies."
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
                            .frame(width: 310, height: isRegular ? 460 : 390)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16) // Allows scrolling edge-to-edge
                }

                // Horizontal swipable row for Graphs and Sliders
                if isRegular {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Graphs",
                            description: "Switch between X vs Time (horizontal position) and Y vs Time (vertical position). The graph updates as the simulation runs."
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Picker("Graph", selection: Binding(
                                    get: { viewModel.selectedAxis },
                                    set: { viewModel.selectedAxis = $0 }
                                )) {
                                    Text("X vs Time").tag(ProjectileAxis.x)
                                    Text("Y vs Time").tag(ProjectileAxis.y)
                                }
                                .pickerStyle(.segmented)
                                ProjectileSegmentedGraphView(
                                    segments: viewModel.currentGraphSegments,
                                    title: viewModel.selectedAxis == .x
                                        ? "Horizontal Position vs Time"
                                        : "Vertical Position vs Time",
                                    yLabel: viewModel.selectedAxis == .x ? "X (m)" : "Y (m)",
                                    currentTime: viewModel.currentTime
                                )
                                .frame(height: 280)
                                .accessibilityElement()
                                .accessibilityLabel(viewModel.graphAccessibilityLabel)
                                .accessibilityAddTraits(.updatesFrequently)
                                .accessibilityHint("Double-tap to hear graph description. Use the X vs Time / Y vs Time picker to switch axes.")
                                if viewModel.xSegments.count > 1 {
                                    HStack(spacing: 16) {
                                        HStack(spacing: 4) {
                                            Rectangle()
                                                .fill(viewModel.selectedAxis == .x ? Color.blue : Color.green)
                                                .frame(width: 20, height: 3)
                                            Text("Active")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        HStack(spacing: 4) {
                                            Rectangle()
                                                .fill((viewModel.selectedAxis == .x ? Color.blue : Color.green).opacity(0.3))
                                                .frame(width: 20, height: 3)
                                            Text("Predicted")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(Color.orange)
                                                .frame(width: 8, height: 8)
                                            Text("Change Point")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "Adjust Parameters",
                            description: "Change launch speed and angle here. After you change a value, the trajectory and graphs update so you can see the effect."
                        ) {
                            EnhancedProjectileControlsView(viewModel: viewModel)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            TitledCard(
                                title: "Graphs",
                                description: "Switch between X vs Time (horizontal position) and Y vs Time (vertical position). The graph updates as the simulation runs."
                            ) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Picker("Graph", selection: Binding(
                                        get: { viewModel.selectedAxis },
                                        set: { viewModel.selectedAxis = $0
                                        }
                                    )) {
                                        Text("X vs Time").tag(ProjectileAxis.x)
                                        Text("Y vs Time").tag(ProjectileAxis.y)
                                    }
                                    .pickerStyle(.segmented)
                                    ProjectileSegmentedGraphView(
                                        segments: viewModel.currentGraphSegments,
                                        title: viewModel.selectedAxis == .x
                                            ? "Horizontal Position vs Time"
                                            : "Vertical Position vs Time",
                                        yLabel: viewModel.selectedAxis == .x ? "X (m)" : "Y (m)",
                                        currentTime: viewModel.currentTime
                                    )
                                    .frame(height: 280)
                                    .accessibilityElement()
                                    .accessibilityLabel(viewModel.graphAccessibilityLabel)
                                    .accessibilityAddTraits(.updatesFrequently)
                                    .accessibilityHint("Double-tap to hear graph description. Use the X vs Time / Y vs Time picker to switch axes.")
                                    if viewModel.xSegments.count > 1 {
                                        HStack(spacing: 16) {
                                            HStack(spacing: 4) {
                                                Rectangle()
                                                    .fill(viewModel.selectedAxis == .x ? Color.blue : Color.green)
                                                    .frame(width: 20, height: 3)
                                                Text("Active")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                            HStack(spacing: 4) {
                                                Rectangle()
                                                    .fill((viewModel.selectedAxis == .x ? Color.blue : Color.green).opacity(0.3))
                                                    .frame(width: 20, height: 3)
                                                Text("Predicted")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                            HStack(spacing: 4) {
                                                Circle()
                                                    .fill(Color.orange)
                                                    .frame(width: 8, height: 8)
                                                Text("Change Point")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: 310, height: isRegular ? 460 : 390)

                            TitledCard(
                                title: "Adjust Parameters",
                                description: "Change launch speed and angle here. After you change a value, the trajectory and graphs update so you can see the effect."
                            ) {
                                EnhancedProjectileControlsView(viewModel: viewModel)
                            }
                            .frame(width: 310, height: isRegular ? 460 : 390)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16) // Allows scrolling edge-to-edge
                }

                if let lastChange = viewModel.changeEvents.last,
                   viewModel.currentTime - lastChange.time < 1.0 {
                    ChangeImpactView(
                        changeType: lastChange.speedAfter != nil ? "Launch Speed" : "Launch Angle",
                        icon: lastChange.speedAfter != nil ? "speedometer" : "angle",
                        beforeValue: lastChange.speedAfter != nil ?
                            String(format: "%.1f m/s", lastChange.speedBefore ?? 0) :
                            String(format: "%.0f°", lastChange.angleBefore ?? 0),
                        afterValue: lastChange.speedAfter != nil ?
                            String(format: "%.1f m/s", lastChange.speedAfter ?? 0) :
                            String(format: "%.0f°", lastChange.angleAfter ?? 0),
                        impact: lastChange.speedAfter != nil ?
                            "Higher speed increases both range and maximum height. Watch how the parabola expands!" :
                            "Different angles create different trajectories. 45° typically gives maximum range!",
                        color: lastChange.speedAfter != nil ? .blue : .green
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .sheet(isPresented: $showingGraphInfo) {
            ProjectileMotionGraphInfoSheet()
        }
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let arrowHeadLength: CGFloat = min(rect.width * 0.2, 12)
        let arrowHeadWidth: CGFloat = min(rect.height * 0.6, 8)
        let shaftWidth: CGFloat = min(rect.height * 0.3, 3)


        path.addRect(CGRect(x: 0, y: (rect.height - shaftWidth) / 2,
                           width: rect.width - arrowHeadLength, height: shaftWidth))


        path.move(to: CGPoint(x: rect.width - arrowHeadLength, y: (rect.height - arrowHeadWidth) / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - arrowHeadLength, y: (rect.height + arrowHeadWidth) / 2))
        path.closeSubpath()

        return path
    }
}

struct ProjectileSimulationView: View {
    var viewModel: ProjectileMotionViewModel
    @Binding var showingGraphInfo: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("Time: \(String(format: "%.2f", viewModel.currentTime)) s")
                        .font(.headline)
                        .fontWeight(.semibold)
                    HStack(spacing: 4) {
                        Text("Phase:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(viewModel.flightPhaseDescription)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                    }
                }

                Spacer()


                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 8) {
                        Circle().fill(Color.blue).frame(width: 10, height: 10)
                        Text("vₓ = \(String(format: "%.1f", viewModel.currentVelocity.dx)) m/s")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .fontWeight(.semibold)
                    }
                    HStack(spacing: 8) {
                        Circle().fill(Color.green).frame(width: 10, height: 10)
                        Text("vᵧ = \(String(format: "%.1f", viewModel.currentVelocity.dy)) m/s")
                            .font(.system(size: 14))
                            .foregroundStyle(.green)
                            .fontWeight(.semibold)
                    }
                    HStack(spacing: 8) {
                        Circle().fill(Color.red).frame(width: 10, height: 10)
                        Text("v = \(String(format: "%.1f", viewModel.currentSpeedMagnitude)) m/s")
                            .font(.system(size: 14))
                            .foregroundStyle(.red)
                            .fontWeight(.semibold)
                    }
                    HStack(spacing: 8) {
                        Text("θ = \(String(format: "%.1f", viewModel.currentVelocityAngle))°")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                    }
                }
                .padding(12)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }

            GeometryReader { geometry in
                ZStack {

                    Path { path in
                        let bounds = viewModel.worldBounds()


                        for i in 0...2 {
                            let y = 20 + (geometry.size.height - 40) * CGFloat(i) / 2
                            path.move(to: CGPoint(x: 20, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width - 20, y: y))
                        }
                    }
                    .stroke(Color.gray.opacity(0.05), lineWidth: 0.5)


                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 2)
                        .clipShape(RoundedRectangle(cornerRadius: 1))
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height - 20
                        )


                    Path { path in
                        path.move(to: CGPoint(x: 20,
                                               y: geometry.size.height - 20))
                        path.addLine(to: CGPoint(x: 20, y: 20))
                    }
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)


                    ForEach(Array(viewModel.trajectorySegments.enumerated()), id: \.element.id) { index, segment in
                        drawTrajectorySegment(segment, index: index, in: geometry.size)
                    }


                    if let lastSegment = viewModel.actualTimeline.last {

                        if let apex = viewModel.apexPoint(for: lastSegment) {
                            let scaledPoints = viewModel.scaleTrajectory([apex.point], to: geometry.size)
                            if let point = scaledPoints.first {
                                ZStack {
                                    Circle()
                                        .fill(Color.purple.opacity(0.8))
                                        .frame(width: 10, height: 10)
                                    Circle()
                                        .stroke(Color.purple, lineWidth: 1.5)
                                        .frame(width: 14, height: 14)
                                }
                                .position(point)

                                Text("Apex: \(String(format: "%.1f", apex.height))m")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.purple)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .shadow(color: .black.opacity(0.1), radius: 2)
                                    .position(x: point.x, y: max(30, point.y - 18))
                            }
                        }


                        let range = viewModel.rangePoint(for: lastSegment)
                        let scaledRange = viewModel.scaleTrajectory([range.point], to: geometry.size)
                        if let point = scaledRange.first {
                            Path { path in
                                path.move(to: CGPoint(x: point.x, y: geometry.size.height - 60))
                                path.addLine(to: CGPoint(x: point.x, y: geometry.size.height - 20))
                            }
                            .stroke(Color.cyan.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [4, 2]))

                            Text("Range: \(String(format: "%.1f", range.range))m")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.cyan.opacity(0.9))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.white.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(color: .black.opacity(0.1), radius: 2)
                                .position(x: point.x, y: geometry.size.height - 48)
                        }
                    }


                    let breakpoints = viewModel.trajectorySegments
                        .filter { $0.role == .actual && $0.startTime > 0 }
                        .sorted { $0.startTime < $1.startTime }

                    ForEach(Array(breakpoints.enumerated()), id: \.offset) { index, segment in
                        if let firstPoint = segment.points.first {
                            let scaled = viewModel.scaleTrajectory([firstPoint], to: geometry.size)
                            if let point = scaled.first {
                                ZStack {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 14, height: 14)

                                    Text("\(index + 1)")
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                .position(point)
                            }
                        }
                    }


                    if viewModel.showVectors {
                        let projectilePos = viewModel.projectilePosition(in: geometry.size)
                        let vel = viewModel.currentVelocity


                        let vectorScale: CGFloat = 3.0
                        let vxLength = CGFloat(abs(vel.dx)) * vectorScale
                        let vyLength = CGFloat(abs(vel.dy)) * vectorScale
                        let resultantLength = sqrt(vel.dx * vel.dx + vel.dy * vel.dy)
                        let vLength = CGFloat(resultantLength) * vectorScale


                        let angleRad = atan2(vel.dy, vel.dx)
                        let angleDeg = angleRad * 180 / .pi


                        if vLength > 5 {
                            ArrowShape()
                                .fill(Color.red)
                                .frame(width: vLength, height: 10)
                                .rotationEffect(.degrees(-angleDeg))
                                .position(x: projectilePos.x + vLength / 2 * cos(angleRad),
                                         y: projectilePos.y - vLength / 2 * sin(angleRad))

                            Text("v")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                                .position(x: projectilePos.x + (vLength / 2 + 12) * cos(angleRad),
                                         y: projectilePos.y - (vLength / 2 + 12) * sin(angleRad))
                        }


                        if vxLength > 5 {
                            ArrowShape()
                                .fill(Color.blue)
                                .frame(width: vxLength, height: 8)
                                .position(x: projectilePos.x + vxLength / 2, y: projectilePos.y)

                            Text("vₓ")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                                .position(x: projectilePos.x + vxLength + 12, y: projectilePos.y)
                        }


                        if vyLength > 5 {
                            ArrowShape()
                                .fill(Color.green)
                                .frame(width: vyLength, height: 8)
                                .rotationEffect(.degrees(vel.dy > 0 ? -90 : 90))
                                .position(x: projectilePos.x,
                                         y: vel.dy > 0 ? projectilePos.y - vyLength / 2 : projectilePos.y + vyLength / 2)

                            Text("vᵧ")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                                .position(x: projectilePos.x - 12,
                                         y: vel.dy > 0 ? projectilePos.y - vyLength / 2 : projectilePos.y + vyLength / 2)
                        }
                    }


                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .red.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 20, height: 20)
                        .shadow(color: .red.opacity(0.3), radius: 4, x: 0, y: 2)
                        .position(
                            viewModel.projectilePosition(in: geometry.size)
                        )
                        .accessibilityElement()
                        .accessibilityLabel(viewModel.simulationBodyAccessibilityLabel)
                        .accessibilityAddTraits(.updatesFrequently)
                }
            }


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

                Button(action: {
                    Haptics.toggleChanged()
                    viewModel.showVectors.toggle()
                }) {
                    Image(systemName: viewModel.showVectors ? "arrow.up.right.circle.fill" : "arrow.up.right.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(.purple)
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


    private func drawTrajectorySegment(_ segment: ProjectileGraphSegment, index: Int, in size: CGSize) -> some View {
        let points = segment.points

        return Group {
            if points.count > 1 {
                Path { path in
                    let scaled = viewModel.scaleTrajectory(points, to: size)
                    guard !scaled.isEmpty else { return }
                    path.move(to: scaled[0])
                    for p in scaled.dropFirst() {
                        path.addLine(to: p)
                    }
                }
                .stroke(
                    Color.blue.opacity(segment.role == .actual ? 0.75 : 0.2),
                    style: StrokeStyle(
                        lineWidth: segment.role == .actual ? 2 : 1.5,
                        lineCap: .round,
                        lineJoin: .round,
                        dash: segment.role == .actual ? [] : [5, 3]
                    )
                )
            } else {
                EmptyView()
            }
        }
    }
}

enum ProjectileSegmentRole {
    case actual
    case prediction
}

