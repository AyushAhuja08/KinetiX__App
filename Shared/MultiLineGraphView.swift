import SwiftUI

struct MultiLineGraphView: View {

    struct Line {
        let points: [CGPoint]
        let color: Color
        let label: String
    }

    let lines: [Line]
    let title: String
    let currentTime: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            GeometryReader { geometry in
                ZStack {

                    Path { path in
                        path.move(to: CGPoint(x: 30, y: 0))
                        path.addLine(to: CGPoint(x: 30,
                                                  y: geometry.size.height - 20))
                        path.addLine(to: CGPoint(x: geometry.size.width,
                                                  y: geometry.size.height - 20))
                    }
                    .stroke(Color.gray, lineWidth: 1)

                    ForEach(lines.indices, id: \.self) { index in
                        drawLine(
                            lines[index],
                            in: geometry.size
                        )
                    }

                    let xPos = 30 + (geometry.size.width - 30)
                        * CGFloat(currentTime / 10)

                    Path { path in
                        path.move(to: CGPoint(x: xPos, y: 0))
                        path.addLine(to: CGPoint(x: xPos,
                                                  y: geometry.size.height - 20))
                    }
                    .stroke(Color.red.opacity(0.4), lineWidth: 1)
                }
            }
            .frame(height: 250)

            HStack(spacing: 12) {
                ForEach(lines.indices, id: \.self) { index in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(lines[index].color)
                            .frame(width: 8, height: 8)
                        Text(lines[index].label)
                            .font(.caption2)
                    }
                }
            }
        }
    }

    private func yBounds() -> (min: Double, max: Double) {
        let allY = lines.flatMap { $0.points }.map { $0.y }
        return (allY.min() ?? 0, allY.max() ?? 1)
    }

    private func mapX(_ x: Double, width: CGFloat) -> CGFloat {
        30 + (width - 30) * CGFloat(x / 10)
    }

    private func mapY(_ y: Double, minY: Double, rangeY: Double, height: CGFloat) -> CGFloat {
        let graphHeight: CGFloat = height - 20
        let normalized = CGFloat((y - minY) / rangeY)
        return graphHeight - normalized * graphHeight
    }

    private func drawLine(_ line: Line, in size: CGSize) -> some View {
        let visible = line.points.filter { $0.x <= currentTime }
        let bounds = yBounds()
        let minY = bounds.min
        let rangeY = max(bounds.max - minY, 1)

        let path = Path { p in
            guard visible.count > 1 else { return }
            let first = visible[0]
            p.move(to: CGPoint(
                x: mapX(first.x, width: size.width),
                y: mapY(first.y, minY: minY, rangeY: rangeY, height: size.height)
            ))
            for point in visible.dropFirst() {
                p.addLine(to: CGPoint(
                    x: mapX(point.x, width: size.width),
                    y: mapY(point.y, minY: minY, rangeY: rangeY, height: size.height)
                ))
            }
        }

        return path.stroke(line.color, lineWidth: 2)
    }
}

#Preview {
    let sampleTime: Double = 5

    let distance: [CGPoint] = (0...100).map { i in
        let t = Double(i) / 10.0
        return CGPoint(x: t, y: 2 * t + 0.5 * t * t)
    }

    let velocity: [CGPoint] = (0...100).map { i in
        let t = Double(i) / 10.0
        return CGPoint(x: t, y: 2 + t)
    }

    let acceleration: [CGPoint] = (0...100).map { i in
        let t = Double(i) / 10.0
        return CGPoint(x: t, y: 1)
    }

    let lines: [MultiLineGraphView.Line] = [
        .init(points: distance, color: .blue, label: "Distance"),
        .init(points: velocity, color: .green, label: "Velocity"),
        .init(points: acceleration, color: .orange, label: "Acceleration")
    ]

    return MultiLineGraphView(lines: lines, title: "Motion Comparison", currentTime: sampleTime)
        .padding(16)
}
