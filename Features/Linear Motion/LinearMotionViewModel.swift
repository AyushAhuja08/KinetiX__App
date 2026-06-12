

import SwiftUI
import Combine
import Observation

struct LinearChangeEvent: Identifiable {
    let id = UUID()
    let time: Double
    var distanceAtChange: Double
    var velocityAtChange: Double
    var velocitySettingBefore: Double?
    var velocitySettingAfter: Double?
    var accelerationBefore: Double?
    var accelerationAfter: Double?


    var changedParameter: String {
        if velocitySettingBefore != nil { return "Initial Velocity" }
        if accelerationBefore != nil    { return "Acceleration" }
        return "Parameter"
    }

    var headline: String {
        if let vb = velocitySettingBefore, let va = velocitySettingAfter {
            return va > vb
                ? String(format: "↑ Velocity increased  %.1f → %.1f m/s", vb, va)
                : String(format: "↓ Velocity decreased  %.1f → %.1f m/s", vb, va)
        }
        if let ab = accelerationBefore, let aa = accelerationAfter {
            return aa > ab
                ? String(format: "↑ Acceleration increased  %.1f → %.1f m/s²", ab, aa)
                : String(format: "↓ Acceleration decreased  %.1f → %.1f m/s²", ab, aa)
        }
        return String(format: "Parameter changed at t = %.2f s", time)
    }

    var physicsExplanation: String {
        if let vb = velocitySettingBefore, let va = velocitySettingAfter {
            let diff = va - vb
            if abs(diff) < 0.01 { return "No significant change in velocity." }
            let direction = diff > 0 ? "increased" : "decreased"
            return """
You \(direction) initial velocity from \(String(format: "%.1f", vb)) m/s to \(String(format: "%.1f", va)) m/s at t = \(String(format: "%.2f", time)) s.

From the SUVAT equation:  s = s₀ + v·t + ½·a·t²

A higher initial velocity shifts the entire distance curve upward — the object covers more ground in any given time. The velocity graph shifts up by \(String(format: "%.1f", abs(diff))) m/s from the change point onward.

At the moment of change:
  • Position was: \(String(format: "%.2f", distanceAtChange)) m
  • Velocity was: \(String(format: "%.2f", velocityAtChange)) m/s
  • New motion restarts from here with v₀ = \(String(format: "%.1f", va)) m/s
"""
        }

        if let ab = accelerationBefore, let aa = accelerationAfter {
            let diff = aa - ab
            let direction = diff > 0 ? "increased" : "decreased"
            let curveEffect = aa > 0 ? "curves upward (speeding up)" : aa < 0 ? "curves downward (slowing down)" : "becomes a straight line (constant velocity)"
            return """
You \(direction) acceleration from \(String(format: "%.1f", ab)) m/s² to \(String(format: "%.1f", aa)) m/s² at t = \(String(format: "%.2f", time)) s.

Acceleration is the slope of the velocity graph. Changing it means:
  • Velocity graph slope changes → now \(String(format: "%.1f", aa)) m/s² per second
  • Distance graph \(curveEffect)

From SUVAT:  v = v₀ + a·t  and  s = v₀t + ½at²

At the moment of change:
  • Position: \(String(format: "%.2f", distanceAtChange)) m
  • Velocity: \(String(format: "%.2f", velocityAtChange)) m/s (this becomes the new v₀)
  • New slope on velocity graph: \(String(format: "%.1f", aa)) m/s²
"""
        }

        return "Parameter changed at t = \(String(format: "%.2f", time)) s."
    }

    var paramIcon: String {
        if velocitySettingBefore != nil { return "speedometer" }
        if accelerationBefore != nil    { return "gauge.high" }
        return "slider.horizontal.3"
    }

    var paramColor: Color {
        if velocitySettingBefore != nil { return .green }
        if accelerationBefore != nil    { return .orange }
        return .blue
    }
}

struct LinearLastChangeSummary {
    let changeTime: Double
    let actualDistanceAtEnd: Double
    let predictedDistanceAtEnd: Double
    let actualVelocityAtEnd: Double
    let predictedVelocityAtEnd: Double
}

@Observable
class LinearMotionViewModel {
    var initialVelocity: Double = 5.0
    var acceleration: Double = 2.0
    var manualTime: Double = 0.0 { didSet { currentTime = manualTime } }

    var selectedGraph: GraphType = .distance
    var isPlaying: Bool = false
    var currentTime: Double = 0.0

    var distanceSegments: [GraphSegment] = []
    var velocitySegments: [GraphSegment] = []
    var accelerationSegments: [GraphSegment] = []

    var changeEvents: [LinearChangeEvent] = []

    private struct LinearKinematicsSegment {
        var startTime: Double
        var endTime: Double
        var startDistance: Double
        var startVelocity: Double
        var acceleration: Double
    }

    private var actualTimeline: [LinearKinematicsSegment] = []
    private var predictionTimeline: [LinearKinematicsSegment] = []

    private var timer: AnyCancellable?
    private let maxTime: Double = 10.0

    init() {
        rebuildTimelineFromScratch()
    }

    var currentGraphSegments: [GraphSegment] {
        switch selectedGraph {
        case .distance: return distanceSegments
        case .velocity: return velocitySegments
        case .acceleration: return accelerationSegments
        }
    }

    var currentInsight: String {
        if abs(acceleration) < 0.1 {
            return "Zero acceleration → constant velocity"
        } else if acceleration > 0 {
            return "Positive acceleration → velocity increases"
        } else {
            return "Negative acceleration → velocity decreases"
        }
    }

    func objectPosition(in width: CGFloat) -> CGFloat {
        let distance = distance(at: currentTime)
        let normalized = (distance / 50.0) + 0.5
        return width * CGFloat(max(0, min(1, normalized)))
    }

    func playPause() {
        isPlaying.toggle()
        isPlaying ? startTimer() : stopTimer()
    }

    func reset() {
        stopTimer()
        isPlaying = false
        currentTime = 0
        manualTime = 0
        rebuildTimelineFromScratch()
    }

    var currentDistance: Double { distance(at: currentTime) }
    var currentVelocity: Double { velocity(at: currentTime) }
    var currentAcceleration: Double { acceleration(at: currentTime) }

    var lastChangeSummary: LinearLastChangeSummary? {
        guard let lastEvent = changeEvents.last else { return nil }
        guard let lastPrediction = predictionTimeline.last else { return nil }

        let tEnd = maxTime

        let actualD = distance(at: tEnd)
        let actualV = velocity(at: tEnd)

        let predictedLocalT = tEnd - lastPrediction.startTime
        let predictedD = lastPrediction.startDistance
            + lastPrediction.startVelocity * predictedLocalT
            + 0.5 * lastPrediction.acceleration * predictedLocalT * predictedLocalT
        let predictedV = lastPrediction.startVelocity + lastPrediction.acceleration * predictedLocalT

        return LinearLastChangeSummary(
            changeTime: lastEvent.time,
            actualDistanceAtEnd: actualD,
            predictedDistanceAtEnd: predictedD,
            actualVelocityAtEnd: actualV,
            predictedVelocityAtEnd: predictedV
        )
    }

    func setInitialVelocity(_ newValue: Double) {
        let t = max(0, min(maxTime, currentTime))

        if t <= 0.0001 {
            initialVelocity = newValue
            rebuildTimelineFromScratch()
            return
        }

        let beforeSetting = initialVelocity
        let dAtChange = distance(at: t)
        let vAtChange = velocity(at: t)

        initialVelocity = newValue
        upsertChangeEvent(
            at: t,
            distance: dAtChange,
            velocity: vAtChange,
            velocityBefore: beforeSetting,
            velocityAfter: newValue,
            accelBefore: nil,
            accelAfter: nil
        )

        applyParameterChange(at: t, velocityChanged: true)
    }

    func setAcceleration(_ newValue: Double) {
        let t = max(0, min(maxTime, currentTime))

        if t <= 0.0001 {
            acceleration = newValue
            rebuildTimelineFromScratch()
            return
        }

        let beforeSetting = acceleration
        let dAtChange = distance(at: t)
        let vAtChange = velocity(at: t)

        acceleration = newValue
        upsertChangeEvent(
            at: t,
            distance: dAtChange,
            velocity: vAtChange,
            velocityBefore: nil,
            velocityAfter: nil,
            accelBefore: beforeSetting,
            accelAfter: newValue
        )

        applyParameterChange(at: t, velocityChanged: false)
    }



    private func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.currentTime += 0.05
                self.manualTime = self.currentTime
                if self.currentTime >= self.maxTime {
                    self.reset()
                }
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func rebuildTimelineFromScratch() {
        changeEvents = []

        actualTimeline = [
            LinearKinematicsSegment(
                startTime: 0,
                endTime: maxTime,
                startDistance: 0,
                startVelocity: initialVelocity,
                acceleration: acceleration
            )
        ]
        predictionTimeline = []
        rebuildGraphSegments()
    }

    private func upsertChangeEvent(
        at time: Double,
        distance: Double,
        velocity: Double,
        velocityBefore: Double?,
        velocityAfter: Double?,
        accelBefore: Double?,
        accelAfter: Double?
    ) {
        if let lastIndex = changeEvents.indices.last,
           abs(changeEvents[lastIndex].time - time) < 1e-6 {
            var updated = changeEvents[lastIndex]
            updated.distanceAtChange = distance
            updated.velocityAtChange = velocity

            if let vb = velocityBefore { updated.velocitySettingBefore = vb }
            if let va = velocityAfter { updated.velocitySettingAfter = va }
            if let ab = accelBefore { updated.accelerationBefore = ab }
            if let aa = accelAfter { updated.accelerationAfter = aa }

            changeEvents[lastIndex] = updated
        } else {
            changeEvents.append(
                LinearChangeEvent(
                    time: time,
                    distanceAtChange: distance,
                    velocityAtChange: velocity,
                    velocitySettingBefore: velocityBefore,
                    velocitySettingAfter: velocityAfter,
                    accelerationBefore: accelBefore,
                    accelerationAfter: accelAfter
                )
            )
        }
    }

    private func applyParameterChange(at time: Double, velocityChanged: Bool) {
        let t = max(0, min(maxTime, time))

        if t <= 0.0001 {
            rebuildTimelineFromScratch()
            return
        }

        if actualTimeline.count >= 2, abs(actualTimeline.last!.startTime - t) < 1e-6 {
            let prev = actualTimeline[actualTimeline.count - 2]
            let dt = t - prev.startTime

            let distanceAtChange = prev.startDistance
                + prev.startVelocity * dt
                + 0.5 * prev.acceleration * dt * dt
            let velocityAtChange = prev.startVelocity + prev.acceleration * dt

            let newStartVelocity = velocityChanged ? initialVelocity : velocityAtChange
            actualTimeline[actualTimeline.count - 1] = LinearKinematicsSegment(
                startTime: t,
                endTime: maxTime,
                startDistance: distanceAtChange,
                startVelocity: newStartVelocity,
                acceleration: acceleration
            )

            rebuildGraphSegments()
            return
        }

        guard let (segmentIndex, segment) = actualSegment(containing: t) else {
            rebuildTimelineFromScratch()
            return
        }

        actualTimeline = Array(actualTimeline.prefix(segmentIndex + 1))
        predictionTimeline.removeAll { $0.startTime >= t }

        let dt = t - segment.startTime
        let distanceAtChange = segment.startDistance
            + segment.startVelocity * dt
            + 0.5 * segment.acceleration * dt * dt
        let velocityAtChange = segment.startVelocity + segment.acceleration * dt

        actualTimeline[segmentIndex].endTime = t

        predictionTimeline.append(
            LinearKinematicsSegment(
                startTime: t,
                endTime: maxTime,
                startDistance: distanceAtChange,
                startVelocity: velocityAtChange,
                acceleration: segment.acceleration
            )
        )

        let newStartVelocity = velocityChanged ? initialVelocity : velocityAtChange
        actualTimeline.append(
            LinearKinematicsSegment(
                startTime: t,
                endTime: maxTime,
                startDistance: distanceAtChange,
                startVelocity: newStartVelocity,
                acceleration: acceleration
            )
        )

        rebuildGraphSegments()
    }

    private func actualSegment(containing t: Double) -> (Int, LinearKinematicsSegment)? {
        for (idx, seg) in actualTimeline.enumerated().reversed() {
            if t >= seg.startTime && t <= seg.endTime {
                return (idx, seg)
            }
        }
        return nil
    }

    private func distance(at time: Double) -> Double {
        guard let (_, seg) = actualSegment(containing: time) else { return 0 }
        let dt = time - seg.startTime
        return seg.startDistance + seg.startVelocity * dt + 0.5 * seg.acceleration * dt * dt
    }

    private func velocity(at time: Double) -> Double {
        guard let (_, seg) = actualSegment(containing: time) else { return initialVelocity }
        let dt = time - seg.startTime
        return seg.startVelocity + seg.acceleration * dt
    }

    private func acceleration(at time: Double) -> Double {
        guard let (_, seg) = actualSegment(containing: time) else { return acceleration }
        return seg.acceleration
    }

    private func rebuildGraphSegments() {
        let distancePred = predictionTimeline.map {
            makeGraphSegment(from: $0, type: .distance, color: .blue, role: .prediction)
        }
        let distanceAct = actualTimeline.map {
            makeGraphSegment(from: $0, type: .distance, color: .blue, role: .actual)
        }
        distanceSegments = distancePred + distanceAct

        let velocityPred = predictionTimeline.map {
            makeGraphSegment(from: $0, type: .velocity, color: .green, role: .prediction)
        }
        let velocityAct = actualTimeline.map {
            makeGraphSegment(from: $0, type: .velocity, color: .green, role: .actual)
        }
        velocitySegments = velocityPred + velocityAct

        let accelPred = predictionTimeline.map {
            makeGraphSegment(from: $0, type: .acceleration, color: .orange, role: .prediction)
        }
        let accelAct = actualTimeline.map {
            makeGraphSegment(from: $0, type: .acceleration, color: .orange, role: .actual)
        }
        accelerationSegments = accelPred + accelAct
    }

    private func makeGraphSegment(from segment: LinearKinematicsSegment, type: GraphType, color: Color, role: GraphSegmentRole) -> GraphSegment {
        let steps = 200
        let duration = max(segment.endTime - segment.startTime, 0)

        var points: [CGPoint] = []
        points.reserveCapacity(steps + 1)

        for i in 0...steps {
            let localT = (Double(i) / Double(steps)) * duration
            let t = segment.startTime + localT

            let value: Double
            switch type {
            case .distance:
                value = segment.startDistance + segment.startVelocity * localT + 0.5 * segment.acceleration * localT * localT
            case .velocity:
                value = segment.startVelocity + segment.acceleration * localT
            case .acceleration:
                value = segment.acceleration
            }

            points.append(CGPoint(x: t, y: value))
        }

        return GraphSegment(
            points: points,
            color: color,
            startTime: segment.startTime,
            endTime: segment.endTime,
            role: role
        )
    }
}
