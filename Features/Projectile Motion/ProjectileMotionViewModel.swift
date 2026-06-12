

import SwiftUI
import Combine
import Observation

struct ProjectileChangeEvent: Identifiable {
    let id = UUID()
    let time: Double
    var positionAtChange: CGPoint
    var velocityAtChange: CGVector
    var speedBefore: Double?
    var speedAfter: Double?
    var angleBefore: Double?
    var angleAfter: Double?


    var changedParameter: String {
        if speedBefore != nil  { return "Launch Speed" }
        if angleBefore != nil  { return "Launch Angle" }
        return "Parameter"
    }

    var headline: String {
        if let sb = speedBefore, let sa = speedAfter {
            return sa > sb
                ? String(format: "↑ Speed increased  %.1f → %.1f m/s", sb, sa)
                : String(format: "↓ Speed decreased  %.1f → %.1f m/s", sb, sa)
        }
        if let ab = angleBefore, let aa = angleAfter {
            return aa > ab
                ? String(format: "↑ Angle increased  %.0f° → %.0f°", ab, aa)
                : String(format: "↓ Angle decreased  %.0f° → %.0f°", ab, aa)
        }
        return String(format: "Parameter changed at t = %.2f s", time)
    }

    var physicsExplanation: String {
        if let sb = speedBefore, let sa = speedAfter {
            let diff = sa - sb
            let direction = diff > 0 ? "increased" : "decreased"

            let angle = atan2(velocityAtChange.dy, velocityAtChange.dx) * 180 / .pi
            return """
You \(direction) launch speed from \(String(format: "%.1f", sb)) m/s to \(String(format: "%.1f", sa)) m/s at t = \(String(format: "%.2f", time)) s.

Both range and height scale with v²:
  Range   R = v²·sin(2θ) / g
  Height  H = v²·sin²(θ) / (2g)

At angle ≈ \(String(format: "%.0f", max(0, angle)))°, a speed of \(String(format: "%.1f", sa)) m/s gives:
  • Estimated Range:  \(String(format: "%.1f", Double(sa)*Double(sa)*sin(2.0 * Double(max(0,angle)) * Double.pi / 180.0) / 9.8)) m
  • Estimated Height: \(String(format: "%.1f", Double(sa)*Double(sa)*pow(sin(Double(max(0,angle)) * Double.pi / 180.0), 2.0) / (2.0*9.8))) m

At the moment of change:
  • x = \(String(format: "%.2f", positionAtChange.x)) m,  y = \(String(format: "%.2f", positionAtChange.y)) m
  • vₓ = \(String(format: "%.2f", velocityAtChange.dx)) m/s,  vᵧ = \(String(format: "%.2f", velocityAtChange.dy)) m/s
"""
        }

        if let ab = angleBefore, let aa = angleAfter {
            let diff = aa - ab
            let direction = diff > 0 ? "increased" : "decreased"
            let is45 = abs(aa - 45) < 3
            let rangeNote = is45
                ? "45° is the optimal angle for maximum range!"
                : aa < 45
                    ? "Below 45°: more horizontal, less time in air, shorter range."
                    : "Above 45°: more vertical, longer time in air, shorter range."
            return """
You \(direction) launch angle from \(String(format: "%.0f", ab))° to \(String(format: "%.0f", aa))°.

Angle determines how velocity splits between axes:
  vₓ = v · cos(θ)   →  horizontal component
  vᵧ = v · sin(θ)   →  vertical component (fights gravity)

\(rangeNote)

Complementary angles (e.g. 30° and 60°) give the same range because the product sin(2θ) is the same.

At the moment of change:
  • x = \(String(format: "%.2f", positionAtChange.x)) m,  y = \(String(format: "%.2f", positionAtChange.y)) m
  • vₓ = \(String(format: "%.2f", velocityAtChange.dx)) m/s,  vᵧ = \(String(format: "%.2f", velocityAtChange.dy)) m/s
"""
        }

        return "Parameter changed at t = \(String(format: "%.2f", time)) s."
    }

    var paramIcon: String {
        if speedBefore != nil  { return "speedometer" }
        if angleBefore != nil  { return "angle" }
        return "slider.horizontal.3"
    }

    var paramColor: Color {
        if speedBefore != nil  { return .blue }
        if angleBefore != nil  { return .orange }
        return .green
    }
}

struct ProjectileLastChangeSummary {
    let changeTime: Double
    let actualLandingTime: Double
    let predictedLandingTime: Double
    let actualRange: Double
    let predictedRange: Double
    let actualPeakHeight: Double
    let predictedPeakHeight: Double
}

struct ProjectileKinematicsSegment {
    var startTime: Double
    var endTime: Double
    var startX: Double
    var startY: Double
    var vx: Double
    var vy: Double
}

@Observable
class ProjectileMotionViewModel {
    var speed: Double = 20.0
    var angle: Double = 45.0
    var selectedAxis: ProjectileAxis = .x
    var currentTime: Double = 0.0
    var manualTime: Double = 0.0 { didSet { currentTime = manualTime } }
    var isPlaying: Bool = false
    var showVectors: Bool = true

    var trajectorySegments: [ProjectileGraphSegment] = []
    var xSegments: [ProjectileGraphSegment] = []
    var ySegments: [ProjectileGraphSegment] = []

    var changeEvents: [ProjectileChangeEvent] = []

    var actualTimeline: [ProjectileKinematicsSegment] = []
    var predictionTimeline: [ProjectileKinematicsSegment] = []

    private var timer: AnyCancellable?
    private let g: Double = 9.8

    var gravity: Double { g }

    init() {
        rebuildTimelineFromScratch()
    }

    var currentGraphSegments: [ProjectileGraphSegment] {
        selectedAxis == .x ? xSegments : ySegments
    }

    var currentInsight: String {
        if abs(angle - 45) < 5 {
            return "45° gives maximum range"
        } else if angle < 30 {
            return "Lower angle → longer range, less height"
        } else {
            return "Higher angle → more height, less range"
        }
    }

    var currentPosition: CGPoint { position(at: currentTime) }

    var currentVelocity: CGVector {
        let v = velocityComponents(at: currentTime)
        return CGVector(dx: v.vx, dy: v.vy)
    }

    var currentSpeedMagnitude: Double {
        let v = velocityComponents(at: currentTime)
        return hypot(v.vx, v.vy)
    }

    var currentVelocityAngle: Double {
        let v = velocityComponents(at: currentTime)
        let angleRad = atan2(v.vy, v.vx)
        return angleRad * 180 / .pi
    }

    var lastChangeSummary: ProjectileLastChangeSummary? {
        guard let lastEvent = changeEvents.last else { return nil }
        guard let predicted = predictionTimeline.last else { return nil }
        guard let actual = actualTimeline.last else { return nil }

        let actualDuration = max(actual.endTime - actual.startTime, 0)
        let predictedDuration = max(predicted.endTime - predicted.startTime, 0)

        let actualRange = actual.startX + actual.vx * actualDuration
        let predictedRange = predicted.startX + predicted.vx * predictedDuration

        let actualPeak = peakHeight(for: actual)
        let predictedPeak = peakHeight(for: predicted)

        return ProjectileLastChangeSummary(
            changeTime: lastEvent.time,
            actualLandingTime: actual.endTime,
            predictedLandingTime: predicted.endTime,
            actualRange: actualRange,
            predictedRange: predictedRange,
            actualPeakHeight: actualPeak,
            predictedPeakHeight: predictedPeak
        )
    }

    func setSpeed(_ newValue: Double) {
        let t = max(0, min(currentTime, actualTimeline.last?.endTime ?? currentTime))

        if t <= 0.0001 {
            speed = newValue
            rebuildTimelineFromScratch()
            return
        }

        let before = speed
        let pos = position(at: t)
        let vel = velocityComponents(at: t)

        speed = newValue
        upsertChangeEvent(
            at: t,
            position: pos,
            velocity: CGVector(dx: vel.vx, dy: vel.vy),
            speedBefore: before,
            speedAfter: newValue,
            angleBefore: nil,
            angleAfter: nil
        )

        applyParameterChange(at: t)
    }

    func setAngle(_ newValue: Double) {
        let t = max(0, min(currentTime, actualTimeline.last?.endTime ?? currentTime))

        if t <= 0.0001 {
            angle = newValue
            rebuildTimelineFromScratch()
            return
        }

        let before = angle
        let pos = position(at: t)
        let vel = velocityComponents(at: t)

        angle = newValue
        upsertChangeEvent(
            at: t,
            position: pos,
            velocity: CGVector(dx: vel.vx, dy: vel.vy),
            speedBefore: nil,
            speedAfter: nil,
            angleBefore: before,
            angleAfter: newValue
        )

        applyParameterChange(at: t)
    }

    func projectilePosition(in size: CGSize) -> CGPoint {
        let currentPos = position(at: currentTime)
        let bounds = worldBounds()

        let scaledX = 20 + (size.width - 40) * CGFloat(currentPos.x / bounds.width)
        let scaledY = size.height - 20 -
            CGFloat(currentPos.y / bounds.height) * (size.height - 40)

        return CGPoint(
            x: max(20, min(size.width - 20, scaledX)),
            y: max(20, min(size.height - 20, scaledY))
        )
    }

    func scaleTrajectory(_ points: [CGPoint], to size: CGSize) -> [CGPoint] {
        let bounds = worldBounds()
        return points.compactMap { point in

            guard point.y >= 0 else { return nil }

            let x = 20 + (size.width - 40) * CGFloat(point.x / bounds.width)
            let y = size.height - 20 -
                CGFloat(point.y / bounds.height) * (size.height - 40)


            let clampedY = max(20, min(size.height - 20, y))
            return CGPoint(x: x, y: clampedY)
        }
    }

    func playPause() {
        isPlaying.toggle()
        isPlaying ? startTimer() : stopTimer()
    }

    func reset() {
        stopTimer()
        isPlaying = false
        currentTime = 0.0
        manualTime = 0.0
        rebuildTimelineFromScratch()
    }

    private func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentTime += 0.05
                self.manualTime = self.currentTime

                if let last = self.actualTimeline.last, self.currentTime >= last.endTime {
                    self.currentTime = last.endTime
                    self.manualTime = self.currentTime
                    self.isPlaying = false
                    self.stopTimer()
                    Haptics.landing()
                }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func rebuildTimelineFromScratch() {
        changeEvents = []

        let rad = angle * .pi / 180
        let vx0 = speed * cos(rad)
        let vy0 = speed * sin(rad)

        let end = landingTime(startY: 0, vy0: vy0)

        actualTimeline = [
            ProjectileKinematicsSegment(
                startTime: 0,
                endTime: end,
                startX: 0,
                startY: 0,
                vx: vx0,
                vy: vy0
            )
        ]
        predictionTimeline = []

        rebuildSegments()
    }

    private func applyParameterChange(at time: Double) {
        let t = max(0, min(time, (actualTimeline.last?.endTime ?? time)))

        if t <= 0.0001 {
            rebuildTimelineFromScratch()
            return
        }




        if actualTimeline.count >= 2, abs(actualTimeline.last!.startTime - t) < 1e-6 {
            let startX = actualTimeline.last!.startX
            let startY = actualTimeline.last!.startY

            let rad = angle * .pi / 180
            let newVX = speed * cos(rad)
            let newVY = speed * sin(rad)
            let newEnd = t + landingTime(startY: startY, vy0: newVY)

            actualTimeline[actualTimeline.count - 1] = ProjectileKinematicsSegment(
                startTime: t,
                endTime: newEnd,
                startX: startX,
                startY: startY,
                vx: newVX,
                vy: newVY
            )

            rebuildSegments()
            return
        }

        guard let (segmentIndex, seg) = actualSegment(containing: t) else {
            rebuildTimelineFromScratch()
            return
        }


        actualTimeline = Array(actualTimeline.prefix(segmentIndex + 1))
        predictionTimeline.removeAll { $0.startTime >= t }

        let dt = t - seg.startTime

        let xAtChange = seg.startX + seg.vx * dt
        let yAtChange = max(0, seg.startY + seg.vy * dt - 0.5 * g * dt * dt)


        let vxAtChange = seg.vx
        let vyAtChange = seg.vy - g * dt


        actualTimeline[segmentIndex].endTime = t


        let predictedEnd = t + landingTime(startY: yAtChange, vy0: vyAtChange)
        predictionTimeline.append(
            ProjectileKinematicsSegment(
                startTime: t,
                endTime: predictedEnd,
                startX: xAtChange,
                startY: yAtChange,
                vx: vxAtChange,
                vy: vyAtChange
            )
        )


        let rad = angle * .pi / 180
        let newVX = speed * cos(rad)
        let newVY = speed * sin(rad)
        let newEnd = t + landingTime(startY: yAtChange, vy0: newVY)

        actualTimeline.append(
            ProjectileKinematicsSegment(
                startTime: t,
                endTime: newEnd,
                startX: xAtChange,
                startY: yAtChange,
                vx: newVX,
                vy: newVY
            )
        )

        rebuildSegments()
    }

    private func actualSegment(containing t: Double) -> (Int, ProjectileKinematicsSegment)? {
        for (idx, seg) in actualTimeline.enumerated().reversed() {
            if t >= seg.startTime && t <= seg.endTime {
                return (idx, seg)
            }
        }
        return nil
    }

    private func position(at time: Double) -> CGPoint {
        guard let (_, seg) = actualSegment(containing: time) else { return .init(x: 0, y: 0) }
        let dt = time - seg.startTime
        let x = seg.startX + seg.vx * dt
        let y = max(0, seg.startY + seg.vy * dt - 0.5 * g * dt * dt)
        return CGPoint(x: x, y: y)
    }

    private func velocityComponents(at time: Double) -> (vx: Double, vy: Double) {
        guard let (_, seg) = actualSegment(containing: time) else {
            return (vx: 0, vy: 0)
        }
        let dt = time - seg.startTime
        let vx = seg.vx
        let vy = seg.vy - g * dt
        return (vx: vx, vy: vy)
    }

    private func upsertChangeEvent(
        at time: Double,
        position: CGPoint,
        velocity: CGVector,
        speedBefore: Double?,
        speedAfter: Double?,
        angleBefore: Double?,
        angleAfter: Double?
    ) {
        if let lastIndex = changeEvents.indices.last,
           abs(changeEvents[lastIndex].time - time) < 1e-6 {
            var updated = changeEvents[lastIndex]
            updated.positionAtChange = position
            updated.velocityAtChange = velocity

            if let sb = speedBefore { updated.speedBefore = sb }
            if let sa = speedAfter { updated.speedAfter = sa }
            if let ab = angleBefore { updated.angleBefore = ab }
            if let aa = angleAfter { updated.angleAfter = aa }

            changeEvents[lastIndex] = updated
        } else {
            changeEvents.append(
                ProjectileChangeEvent(
                    time: time,
                    positionAtChange: position,
                    velocityAtChange: velocity,
                    speedBefore: speedBefore,
                    speedAfter: speedAfter,
                    angleBefore: angleBefore,
                    angleAfter: angleAfter
                )
            )
        }
    }

    private func landingTime(startY: Double, vy0: Double) -> Double {


        let disc = vy0 * vy0 + 2 * g * startY
        if disc <= 0 { return 0 }
        let t = (vy0 + sqrt(disc)) / g
        return max(t, 0)
    }

    private func peakHeight(for seg: ProjectileKinematicsSegment) -> Double {
        let duration = max(seg.endTime - seg.startTime, 0)



        let tPeakUnclamped = seg.vy / g
        let tPeak = max(0, min(duration, tPeakUnclamped))

        let y = seg.startY + seg.vy * tPeak - 0.5 * g * tPeak * tPeak
        return max(y, 0)
    }


    func apexPoint(for seg: ProjectileKinematicsSegment) -> (point: CGPoint, time: Double, height: Double)? {
        let duration = max(seg.endTime - seg.startTime, 0)
        let tPeakUnclamped = seg.vy / g


        guard tPeakUnclamped >= 0 && tPeakUnclamped <= duration else { return nil }

        let tPeak = tPeakUnclamped
        let x = seg.startX + seg.vx * tPeak
        let y = max(0, seg.startY + seg.vy * tPeak - 0.5 * g * tPeak * tPeak)
        let absoluteTime = seg.startTime + tPeak

        return (point: CGPoint(x: x, y: y), time: absoluteTime, height: y)
    }


    func rangePoint(for seg: ProjectileKinematicsSegment) -> (point: CGPoint, time: Double, range: Double) {
        let duration = max(seg.endTime - seg.startTime, 0)
        let x = seg.startX + seg.vx * duration
        let y = 0.0

        return (point: CGPoint(x: x, y: y), time: seg.endTime, range: x)
    }

    private func rebuildSegments() {

        let trajPred = predictionTimeline.map { makeTrajectorySegment(from: $0, role: .prediction) }
        let trajAct = actualTimeline.map { makeTrajectorySegment(from: $0, role: .actual) }
        trajectorySegments = trajPred + trajAct


        let xPred = predictionTimeline.map { makeTimeGraphSegment(from: $0, role: .prediction, axis: .x) }
        let xAct = actualTimeline.map { makeTimeGraphSegment(from: $0, role: .actual, axis: .x) }
        xSegments = xPred + xAct


        let yPred = predictionTimeline.map { makeTimeGraphSegment(from: $0, role: .prediction, axis: .y) }
        let yAct = actualTimeline.map { makeTimeGraphSegment(from: $0, role: .actual, axis: .y) }
        ySegments = yPred + yAct
    }

    private func makeTrajectorySegment(from seg: ProjectileKinematicsSegment, role: ProjectileSegmentRole) -> ProjectileGraphSegment {
        let steps = 120
        let duration = max(seg.endTime - seg.startTime, 0)

        var points: [CGPoint] = []
        points.reserveCapacity(steps + 2)

        for i in 0...steps {
            let localT = (Double(i) / Double(steps)) * duration
            let x = seg.startX + seg.vx * localT
            let y = seg.startY + seg.vy * localT - 0.5 * g * localT * localT


            if y < 0 {



                if i > 0, let prevPoint = points.last, prevPoint.y >= 0 {

                    let prevLocalT = (Double(i - 1) / Double(steps)) * duration
                    let prevY = seg.startY + seg.vy * prevLocalT - 0.5 * g * prevLocalT * prevLocalT
                    let groundT = prevLocalT + (localT - prevLocalT) * (0 - prevY) / (y - prevY)
                    let groundX = seg.startX + seg.vx * groundT
                    points.append(CGPoint(x: groundX, y: 0))
                }
                break
            }

            points.append(CGPoint(x: x, y: max(0, y)))
        }


        if duration > 0 {
            let finalY = seg.startY + seg.vy * duration - 0.5 * g * duration * duration
            if abs(finalY) < 0.01 {
                let finalX = seg.startX + seg.vx * duration
                if let last = points.last, abs(last.y) > 0.01 {
                    points.append(CGPoint(x: finalX, y: 0))
                } else if let last = points.last {
                    points[points.count - 1] = CGPoint(x: finalX, y: 0)
                }
            }
        }

        return ProjectileGraphSegment(
            points: points,
            color: .blue,
            startTime: seg.startTime,
            endTime: seg.endTime,
            role: role
        )
    }

    private func makeTimeGraphSegment(from seg: ProjectileKinematicsSegment, role: ProjectileSegmentRole, axis: ProjectileAxis) -> ProjectileGraphSegment {
        let steps = 120
        let duration = max(seg.endTime - seg.startTime, 0)

        var points: [CGPoint] = []
        points.reserveCapacity(steps + 1)

        for i in 0...steps {
            let localT = (Double(i) / Double(steps)) * duration
            let t = seg.startTime + localT

            let value: Double
            switch axis {
            case .x:
                value = seg.startX + seg.vx * localT
            case .y:
                value = max(0, seg.startY + seg.vy * localT - 0.5 * g * localT * localT)
            }

            points.append(CGPoint(x: t, y: value))
        }

        return ProjectileGraphSegment(
            points: points,
            color: axis == .x ? .blue : .green,
            startTime: seg.startTime,
            endTime: seg.endTime,
            role: role
        )
    }

    func worldBounds() -> (width: Double, height: Double) {
        let all = trajectorySegments.flatMap { $0.points }
        let maxX = all.map { Double($0.x) }.max() ?? 1
        let maxY = all.map { Double($0.y) }.max() ?? 1


        return (
            width: max(maxX * 1.05, 1),
            height: max(maxY * 1.15, 1)
        )
    }
}
