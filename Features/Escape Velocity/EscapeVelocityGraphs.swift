import SwiftUI

enum EscapeVelocityGraphType: Int, CaseIterable, Identifiable {
    case altitude = 0
    case velocity = 1
    case distance = 2
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .altitude: return "Altitude-Time"
        case .velocity: return "Velocity-Time"
        case .distance: return "Distance-Time"
        }
    }
    
    var segmentTitle: String {
        switch self {
        case .altitude: return "Altitude"
        case .velocity: return "Velocity"
        case .distance: return "Distance"
        }
    }
    
    var yLabel: String {
        switch self {
        case .altitude: return "Altitude (km)"
        case .velocity: return "Velocity (km/s)"
        case .distance: return "Distance (km)"
        }
    }
}

struct EscapeVelocityGraphsView: View {
    var viewModel: EscapeVelocityViewModel

    var body: some View {
        VStack(spacing: 12) {
            Picker("Graph Type", selection: Binding(
                get: { viewModel.selectedGraph },
                set: { viewModel.selectedGraph = $0 }
            )) {
                ForEach(EscapeVelocityGraphType.allCases) { type in
                    Text(type.segmentTitle).tag(type)
                }
            }
            .pickerStyle(.segmented)

            EscapeVelocitySingleGraphView(
                points: pointsForSelectedGraph,
                title: viewModel.selectedGraph.title,
                yLabel: viewModel.selectedGraph.yLabel,
                color: colorForSelectedGraph,
                maxTime: 10.0,
                currentTime: viewModel.currentTime,
                showEscapeVelocityLine: viewModel.selectedGraph == .velocity,
                escapeVelocity: viewModel.surfaceEscapeVelocity
            )
            .frame(height: 280)

            Text(descriptionForSelectedGraph)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var pointsForSelectedGraph: [CGPoint] {
        switch viewModel.selectedGraph {
        case .altitude: return viewModel.altitudePoints
        case .velocity: return viewModel.velocityPoints
        case .distance: return viewModel.distancePoints
        }
    }
    
    private var colorForSelectedGraph: Color {
        switch viewModel.selectedGraph {
        case .altitude: return .blue
        case .velocity: return .green
        case .distance: return .purple
        }
    }
    
    private var descriptionForSelectedGraph: String {
        switch viewModel.selectedGraph {
        case .altitude:
            return "Shows how altitude changes over time. Escaping bodies move outward indefinitely, while decaying orbits spiral inward."
        case .velocity:
            return "Red dashed line shows escape velocity. Bodies above this line escape, below it fall back."
        case .distance:
            return "Total distance from planet center (radius + altitude). Watch it increase for escaping trajectories or decrease for falling objects."
        }
    }
}

struct EscapeVelocitySingleGraphView: View {
    let points: [CGPoint]
    let title: String
    let yLabel: String
    let color: Color
    let maxTime: Double
    let currentTime: Double
    var showEscapeVelocityLine: Bool = false
    var escapeVelocity: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            GeometryReader { geometry in
                ZStack {
                    // Grid Background
                    Path { path in
                        for i in 0...10 {
                            let x = 40 + (geometry.size.width - 50) * CGFloat(i) / 10
                            path.move(to: CGPoint(x: x, y: 10))
                            path.addLine(to: CGPoint(x: x, y: geometry.size.height - 25))
                        }

                        for i in 0...5 {
                            let y = 10 + (geometry.size.height - 35) * CGFloat(i) / 5
                            path.move(to: CGPoint(x: 40, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width - 10, y: y))
                        }
                    }
                    .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)

                    // Axes View
                    Path { path in
                        path.move(to: CGPoint(x: 40, y: 10))
                        path.addLine(to: CGPoint(x: 40, y: geometry.size.height - 25))
                        path.addLine(to: CGPoint(x: geometry.size.width - 10, y: geometry.size.height - 25))
                    }
                    .stroke(Color.primary.opacity(0.8), lineWidth: 2)

                    // Escape Velocity Line (dashed red line)
                    if showEscapeVelocityLine && !points.isEmpty {
                        let minY = points.map { $0.y }.min() ?? 0
                        let maxY = points.map { $0.y }.max() ?? 1
                        let rangeY = max(maxY - minY, 1)
                        let normalizedEscapeVel = (escapeVelocity - minY) / rangeY
                        let graphHeight = geometry.size.height - 35
                        let escapeY = (geometry.size.height - 25) - CGFloat(normalizedEscapeVel) * graphHeight

                        if escapeY >= 10 && escapeY <= (geometry.size.height - 25) {
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
                    }

                    // Curve Plot
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

                    // Time cursor (vertical red line)
                    let xPos = 40 + (geometry.size.width - 50) * CGFloat(currentTime / maxTime)
                    if xPos >= 40 && xPos <= (geometry.size.width - 10) {
                        Path { path in
                            path.move(to: CGPoint(x: xPos, y: 10))
                            path.addLine(to: CGPoint(x: xPos, y: geometry.size.height - 25))
                        }
                        .stroke(Color.red.opacity(0.6), lineWidth: 2)
                    }

                    // Labels
                    Text(yLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(-90))
                        .position(x: 12, y: geometry.size.height / 2)

                    Text("Time (s)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 3)
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
            let graphHeight = size.height - 35
            let y = (size.height - 25) - CGFloat(normalizedY) * graphHeight
            return CGPoint(x: x, y: y)
        }
    }
}
