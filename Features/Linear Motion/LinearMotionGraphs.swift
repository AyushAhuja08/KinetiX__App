

import SwiftUI

struct LinearFocusModeGraphView: View {
    var viewModel: LinearMotionViewModel

    var body: some View {
        VStack(spacing: 12) {
            Picker("Graph Type", selection: Binding(
                get: { viewModel.selectedGraph },
                set: { viewModel.selectedGraph = $0 }
            )) {
                Text("Distance").tag(GraphType.distance)
                Text("Velocity").tag(GraphType.velocity)
                Text("Acceleration").tag(GraphType.acceleration)
            }
            .pickerStyle(.segmented)

            SegmentedGraphView(
                segments: viewModel.currentGraphSegments,
                title: viewModel.selectedGraph.title,
                yLabel: viewModel.selectedGraph.yLabel,
                currentTime: viewModel.currentTime
            )
            .frame(height: 280)
            .accessibilityElement()
            .accessibilityLabel(viewModel.graphAccessibilityLabel)
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityHint("Double-tap to hear graph description. Use the picker above to switch between Distance, Velocity, and Acceleration graphs.")


            if viewModel.distanceSegments.count > 1 {
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 3)
                        Text("Active")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
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
                .padding(.horizontal)
            }
        }
    }
}

enum GraphSegmentRole {
    case actual
    case prediction
}

struct GraphSegment: Identifiable {
    let id = UUID()
    let points: [CGPoint]
    let color: Color
    let startTime: Double
    let endTime: Double
    let role: GraphSegmentRole
}

struct SegmentedGraphView: View {
    let segments: [GraphSegment]
    let title: String
    let yLabel: String
    let currentTime: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)

            GeometryReader { geometry in
                ZStack {
                    segmentGridBackground(in: geometry.size, height: geometry.size.height)
                    segmentAxesView(in: geometry.size, height: geometry.size.height)
                    segmentGraphLines(in: geometry.size)
                    segmentBreakpoints(in: geometry.size, height: geometry.size.height)
                    segmentTimeCursor(in: geometry.size, height: geometry.size.height)
                    segmentAxisLabels(in: geometry.size, height: geometry.size.height)
                }
            }
        }
    }

    @ViewBuilder
    private func segmentGridBackground(in size: CGSize, height: CGFloat) -> some View {
        Path { path in

            for i in 0...10 {
                let x = 40 + (size.width - 50) * CGFloat(i) / 10
                path.move(to: CGPoint(x: x, y: 10))
                path.addLine(to: CGPoint(x: x, y: height - 25))
            }

            for i in 0...5 {
                let y = 10 + (height - 35) * CGFloat(i) / 5
                path.move(to: CGPoint(x: 40, y: y))
                path.addLine(to: CGPoint(x: size.width - 10, y: y))
            }
        }
        .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)
    }

    @ViewBuilder
    private func segmentAxesView(in size: CGSize, height: CGFloat) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 40, y: 10))
            path.addLine(to: CGPoint(x: 40, y: height - 25))
            path.addLine(to: CGPoint(x: size.width - 10, y: height - 25))
        }
        .stroke(Color.primary.opacity(0.8), lineWidth: 2)
    }

    //GraphLines
    @ViewBuilder
    private func segmentGraphLines(in size: CGSize) -> some View {
        ForEach(segments.indices, id: \.self) { index in
            drawSegment(segments[index], segmentIndex: index, in: size)
        }
    }

    @ViewBuilder
    private func segmentBreakpoints(in size: CGSize, height: CGFloat) -> some View {
        let breakpoints = segments
            .filter { $0.role == .actual && $0.startTime > 0 }
            .sorted { $0.startTime < $1.startTime }

        ForEach(Array(breakpoints.enumerated()), id: \.offset) { index, segment in
            let xPos = 40 + (size.width - 50) * CGFloat(segment.startTime / 10)

            Path { path in
                path.move(to: CGPoint(x: xPos, y: 10))
                path.addLine(to: CGPoint(x: xPos, y: height - 25))
            }
            .stroke(Color.orange.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [4, 2]))
        }
    }

    @ViewBuilder
    private func segmentTimeCursor(in size: CGSize, height: CGFloat) -> some View {
        let xPos = 40 + (size.width - 50) * CGFloat(currentTime / 10)
        Path { path in
            path.move(to: CGPoint(x: xPos, y: 10))
            path.addLine(to: CGPoint(x: xPos, y: height - 25))
        }
        .stroke(Color.red.opacity(0.6), lineWidth: 2)
    }

    @ViewBuilder
    private func segmentAxisLabels(in size: CGSize, height: CGFloat) -> some View {
        Text(yLabel)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .rotationEffect(.degrees(-90))
            .position(x: 12, y: height / 2)

        Text("Time (s)")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .position(x: size.width / 2, y: height - 3)
    }

    private func drawSegment(_ segment: GraphSegment, segmentIndex: Int, in size: CGSize) -> some View {
        let visiblePoints = segment.points.filter { $0.x >= segment.startTime && $0.x <= segment.endTime }


        let scalePoints = segments.flatMap { seg in
            seg.points.filter { $0.x >= seg.startTime && $0.x <= seg.endTime }
        }

        let minY = scalePoints.map { $0.y }.min() ?? 0
        let maxY = scalePoints.map { $0.y }.max() ?? 1
        let rangeY = max(maxY - minY, 1)

        return Path { path in
            guard visiblePoints.count > 1 else { return }

            let scaledPoints = visiblePoints.map { point -> CGPoint in
                let x = 40 + (size.width - 50) * CGFloat(point.x / 10)


                let normalized = (point.y - minY) / rangeY
                let graphHeight = size.height - 35
                let y = (size.height - 25) - CGFloat(normalized) * graphHeight
                return CGPoint(x: x, y: y)
            }

            path.move(to: scaledPoints[0])
            for point in scaledPoints.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(
            segment.color.opacity(segment.role == .actual ? 1.0 : 0.25),
            style: StrokeStyle(
                lineWidth: segment.role == .actual ? 3 : 2,
                lineCap: .round,
                lineJoin: .round,
                dash: segment.role == .actual ? [] : [6, 3]
            )
        )
    }
}

struct LinearControlSlidersView: View {
    var viewModel: LinearMotionViewModel

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Initial Velocity")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.1f", viewModel.initialVelocity)) m/s")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
                Slider(value: Binding(
                    get: { viewModel.initialVelocity },
                    set: { newValue in
                        viewModel.setInitialVelocity(newValue)
                    }
                ), in: -10...10, step: 0.5)
                .tint(.blue)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in Haptics.sliderEnd() }
                )
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Acceleration")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.1f", viewModel.acceleration)) m/s²")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .fontWeight(.semibold)
                }
                Slider(value: Binding(
                    get: { viewModel.acceleration },
                    set: { newValue in
                        viewModel.setAcceleration(newValue)
                    }
                ), in: -5...5, step: 0.5)
                .tint(.green)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in Haptics.sliderEnd() }
                )
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Time Scrubber")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.2f", viewModel.manualTime)) s")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                        .fontWeight(.semibold)
                }
                Slider(value: Binding(
                    get: { viewModel.manualTime },
                    set: { viewModel.manualTime = $0 }
                ), in: 0...10, step: 0.1)
                    .tint(.orange)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct EnhancedLinearControlsView: View {
    var viewModel: LinearMotionViewModel

    var body: some View {
        VStack(spacing: 16) {
            EducationalSlider(
                label: "Initial Velocity",
                value: Binding(
                    get: { viewModel.initialVelocity },
                    set: { viewModel.setInitialVelocity($0) }
                ),
                range: -10...10,
                step: 0.5,
                unit: "m/s",
                color: .blue,
                icon: "speedometer",
                explanation: viewModel.velocityExplanation
            )

            EducationalSlider(
                label: "Acceleration",
                value: Binding(
                    get: { viewModel.acceleration },
                    set: { viewModel.setAcceleration($0) }
                ),
                range: -5...5,
                step: 0.5,
                unit: "m/s²",
                color: .green,
                icon: "arrow.up.arrow.down",
                explanation: viewModel.accelerationExplanation
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundStyle(.orange)

                        Text("Time Scrubber")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text(String(format: "%.2f", viewModel.manualTime))
                            .font(.subheadline)
                            .foregroundStyle(.orange)
                            .fontWeight(.semibold)
                        Text("s")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Slider(value: Binding(
                    get: { viewModel.manualTime },
                    set: { viewModel.manualTime = $0 }
                ), in: 0...10, step: 0.1)
                    .tint(.orange)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

