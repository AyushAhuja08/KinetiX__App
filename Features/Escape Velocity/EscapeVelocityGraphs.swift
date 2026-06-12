

import SwiftUI

struct EscapeVelocityGraphsView: View {
    var viewModel: EscapeVelocityViewModel

    var body: some View {
        VStack(spacing: 16) {

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Altitude vs Time")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(.blue)
                }

                EscapeVelocityGraphView(
                    points: viewModel.altitudePoints,
                    title: "",
                    yLabel: "Altitude (km)",
                    color: .blue,
                    maxTime: 10.0
                )
                .frame(height: 200)
                .padding(16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Shows how altitude changes over time. Escaping bodies move outward indefinitely, while decaying orbits spiral inward.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }


            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Velocity vs Time")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "speedometer")
                        .foregroundStyle(.green)
                }

                EscapeVelocityGraphView(
                    points: viewModel.velocityPoints,
                    title: "",
                    yLabel: "Velocity (km/s)",
                    color: .green,
                    maxTime: 10.0,
                    showEscapeVelocityLine: true,
                    escapeVelocity: viewModel.surfaceEscapeVelocity
                )
                .frame(height: 200)
                .padding(16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Red dashed line shows escape velocity. Bodies above this line escape, below it fall back.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }


            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Distance from Center")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "arrow.up.and.down.circle")
                        .foregroundStyle(.purple)
                }

                EscapeVelocityGraphView(
                    points: viewModel.distancePoints,
                    title: "",
                    yLabel: "Distance (km)",
                    color: .purple,
                    maxTime: 10.0
                )
                .frame(height: 200)
                .padding(16)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text("Total distance from planet center (radius + altitude). Watch it increase for escaping trajectories or decrease for falling objects.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
    }
}

struct EscapeVelocityGraphView: View {
    let points: [CGPoint]
    let title: String
    let yLabel: String
    let color: Color
    let maxTime: Double
    var showEscapeVelocityLine: Bool = false
    var escapeVelocity: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                Color(.systemBackground)


                Path { path in

                    for i in 0...5 {
                        let x = 40 + (geometry.size.width - 50) * CGFloat(i) / 5
                        path.move(to: CGPoint(x: x, y: 10))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height - 30))
                    }

                    for i in 0...4 {
                        let y = 10 + (geometry.size.height - 40) * CGFloat(i) / 4
                        path.move(to: CGPoint(x: 40, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width - 10, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)


                Path { path in

                    path.move(to: CGPoint(x: 40, y: 10))
                    path.addLine(to: CGPoint(x: 40, y: geometry.size.height - 30))

                    path.addLine(to: CGPoint(x: geometry.size.width - 10, y: geometry.size.height - 30))
                }
                .stroke(Color.gray, lineWidth: 2)


                if showEscapeVelocityLine && !points.isEmpty {
                    //min
                    let minY = points.map { $0.y }.min() ?? 0
                    //max
                    let maxY = points.map { $0.y }.max() ?? 1
                    //range
                    let rangeY = max(maxY - minY, 1)
                    let normalizedEscapeVel = (escapeVelocity - minY) / rangeY
                    let escapeY = geometry.size.height - 30 - CGFloat(normalizedEscapeVel) * (geometry.size.height - 40)

                    Path { path in
                        path.move(to: CGPoint(x: 40, y: escapeY))
                        path.addLine(to: CGPoint(x: geometry.size.width - 10, y: escapeY))
                    }
                    .stroke(Color.red.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [5, 3]))

                    Text("Escape Velocity")
                        .font(.caption2)
                        .foregroundStyle(.red)
                        .position(x: geometry.size.width - 60, y: escapeY - 10)
                }


                if points.count > 1 {
                    Path { path in
                        let scaled = scalePoints(points, to: geometry.size)
                        path.move(to: scaled[0])
                        for p in scaled.dropFirst() {
                            path.addLine(to: p)
                        }
                    }
                    .stroke(color, lineWidth: 3)
                    .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 1)
                }

                //YLabel
                Text(yLabel)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(-90))
                    .position(x: 15, y: geometry.size.height / 2)


                Text("Time (s)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 10)


                ForEach(0..<6) { i in
                    Text("\(i * 2)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .position(
                            x: 40 + (geometry.size.width - 50) * CGFloat(i) / 5,
                            y: geometry.size.height - 15
                        )
                }
            }
        }
    }

    private func scalePoints(_ points: [CGPoint], to size: CGSize) -> [CGPoint] {
        guard !points.isEmpty else { return [] }

        let minY = points.map { $0.y }.min() ?? 0
        let maxY = points.map { $0.y }.max() ?? 1
        let rangeY = max(maxY - minY, 1)

        return points.map { point in
            let x = 40 + (size.width - 50) * CGFloat(point.x / maxTime)
            let normalizedY = (point.y - minY) / rangeY
            let y = size.height - 30 - CGFloat(normalizedY) * (size.height - 40)
            return CGPoint(x: x, y: y)
        }
    }
}
