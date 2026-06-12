

import SwiftUI

struct ProjectileGraphSegment: Identifiable {
    let id = UUID()
    let points: [CGPoint]
    let color: Color
    let startTime: Double
    let endTime: Double
    let role: ProjectileSegmentRole
}

struct ProjectileSegmentedGraphView: View {
    let segments: [ProjectileGraphSegment]
    let title: String
    let yLabel: String
    let currentTime: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            GeometryReader { geometry in
                ZStack {

                    Path { path in

                        for i in 0...10 {
                            let x = 30 + (geometry.size.width - 30) * CGFloat(i) / 10
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height - 20))
                        }

                        for i in 0...5 {
                            let y = (geometry.size.height - 20) * CGFloat(i) / 5
                            path.move(to: CGPoint(x: 30, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                    }
                    .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)


                    Path { path in
                        path.move(to: CGPoint(x: 30, y: 0))
                        path.addLine(to: CGPoint(x: 30,
                                                  y: geometry.size.height - 20))
                        path.addLine(to: CGPoint(x: geometry.size.width,
                                                  y: geometry.size.height - 20))
                    }
                    .stroke(Color.gray, lineWidth: 1)


                    ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                        drawSegment(segment, segmentIndex: index, in: geometry.size)
                    }


                    let breakpoints = segments
                        .filter { $0.role == .actual && $0.startTime > 0 }
                        .sorted { $0.startTime < $1.startTime }

                    ForEach(Array(breakpoints.enumerated()), id: \.offset) { index, segment in
                        let maxTime = segments.flatMap { $0.points }.map { $0.x }.max() ?? 10
                        let xPos = 30 + (geometry.size.width - 30) * CGFloat(segment.startTime / maxTime)

                        Path { path in
                            path.move(to: CGPoint(x: xPos, y: 0))
                            path.addLine(to: CGPoint(x: xPos, y: geometry.size.height - 20))
                        }
                        .stroke(Color.orange, lineWidth: 1.5)

                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 20, height: 20)

                            Text("\(index + 1)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .position(x: xPos, y: 15)
                    }


                    let maxTime = segments.flatMap { $0.points }.map { $0.x }.max() ?? 10
                    let xPos = 30 + (geometry.size.width - 30) * CGFloat(currentTime / maxTime)
                    Path { path in
                        path.move(to: CGPoint(x: xPos, y: 0))
                        path.addLine(to: CGPoint(x: xPos, y: geometry.size.height - 20))
                    }
                    .stroke(Color.red.opacity(0.5), lineWidth: 1)


                    Text(yLabel)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .position(x: 15, y: 10)

                    Text("Time (s)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .position(x: geometry.size.width - 30,
                                  y: geometry.size.height - 5)
                }
            }
        }
    }

    private func drawSegment(_ segment: ProjectileGraphSegment, segmentIndex: Int, in size: CGSize) -> some View {
        let visiblePoints = segment.points.filter { $0.x >= segment.startTime && $0.x <= segment.endTime }

        let scalePoints = segments.flatMap { seg in
            seg.points.filter { $0.x >= seg.startTime && $0.x <= seg.endTime }
        }

        let minY = scalePoints.map { $0.y }.min() ?? 0
        let maxY = scalePoints.map { $0.y }.max() ?? 1
        let rangeY = max(maxY - minY, 1)
        let maxTime = (scalePoints.map { $0.x }.max() ?? 10)

        return Path { path in
            guard visiblePoints.count > 1 else { return }

            let scaledPoints = visiblePoints.map { point -> CGPoint in
                let x = 30 + (size.width - 30) * CGFloat(point.x / maxTime)


                let normalized = (point.y - minY) / rangeY
                let graphHeight = size.height - 20
                let y = (size.height - 20) - CGFloat(normalized) * graphHeight
                return CGPoint(x: x, y: y)
            }

            path.move(to: scaledPoints[0])
            for point in scaledPoints.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(
            segment.color.opacity(segment.role == .actual ? 1.0 : 0.35),
            style: StrokeStyle(
                lineWidth: segment.role == .actual ? 2.5 : 2,
                lineCap: .round,
                lineJoin: .round,
                dash: segment.role == .actual ? [] : [6, 4]
            )
        )
    }
}

struct ProjectileControlsView: View {
    var viewModel: ProjectileMotionViewModel

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Speed")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.1f", viewModel.speed)) m/s")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
                Slider(value: Binding(
                    get: { viewModel.speed },
                    set: { newValue in
                        viewModel.setSpeed(newValue)
                    }
                ), in: 5...30, step: 1)
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
                    Text("Angle")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(String(format: "%.0f", viewModel.angle))°")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .fontWeight(.semibold)
                }
                Slider(value: Binding(
                    get: { viewModel.angle },
                    set: { newValue in
                        viewModel.setAngle(newValue)
                    }
                ), in: 0...90, step: 5)
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
                ), in: 0...(viewModel.actualTimeline.last?.endTime ?? 10), step: 0.05)
                .tint(.orange)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct EnhancedProjectileControlsView: View {
    var viewModel: ProjectileMotionViewModel

    var body: some View {
        VStack(spacing: 16) {
            EducationalSlider(
                label: "Launch Speed",
                value: Binding(
                    get: { viewModel.speed },
                    set: { viewModel.setSpeed($0) }
                ),
                range: 5...30,
                step: 1,
                unit: "m/s",
                color: .blue,
                icon: "speedometer",
                explanation: viewModel.speedExplanation
            )

            EducationalSlider(
                label: "Launch Angle",
                value: Binding(
                    get: { viewModel.angle },
                    set: { viewModel.setAngle($0) }
                ),
                range: 0...90,
                step: 5,
                unit: "°",
                color: .green,
                icon: "angle",
                explanation: viewModel.angleExplanation
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
                ), in: 0...(viewModel.actualTimeline.last?.endTime ?? 10), step: 0.05)
                .tint(.orange)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

