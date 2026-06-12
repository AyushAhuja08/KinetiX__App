
import SwiftUI

// Accessibility helpers for graphs and simulation bodies

extension LinearMotionViewModel {

    // Full VoiceOver description for the simulation body (the moving ball on the track)
    var simulationBodyAccessibilityLabel: String {
        let directionWord: String
        if currentVelocity > 0.1       { directionWord = "moving forward" }
        else if currentVelocity < -0.1 { directionWord = "moving backward" }
        else                           { directionWord = "at rest" }

        return "Simulation object \(directionWord). "
             + "Time: \(String(format: "%.2f", currentTime)) seconds. "
             + "Position: \(String(format: "%.2f", currentDistance)) metres. "
             + "Velocity: \(String(format: "%.2f", currentVelocity)) metres per second. "
             + "Acceleration: \(String(format: "%.2f", acceleration)) metres per second squared. "
             + enhancedPhysicsInsight.explanation
    }

    // VoiceOver description for the currently selected graph
    var graphAccessibilityLabel: String {
        let name: String
        let currentValue: String
        let trend: String

        switch selectedGraph {
        case .distance:
            name = "Distance–Time graph"
            currentValue = "Current distance \(String(format: "%.2f", currentDistance)) metres"
            trend = acceleration > 0.1  ? "curving upward due to positive acceleration"
                  : acceleration < -0.1 ? "curving downward due to negative acceleration"
                  :                       "a straight line showing constant velocity"
        case .velocity:
            name = "Velocity–Time graph"
            currentValue = "Current velocity \(String(format: "%.2f", currentVelocity)) metres per second"
            trend = acceleration > 0.1  ? "sloping upward — speed is increasing"
                  : acceleration < -0.1 ? "sloping downward — speed is decreasing"
                  :                       "flat horizontal line — constant velocity"
        case .acceleration:
            name = "Acceleration–Time graph"
            currentValue = "Constant acceleration \(String(format: "%.2f", acceleration)) metres per second squared"
            trend = "a flat horizontal line"
        }

        let timeProgress = Int((currentTime / 10.0) * 100)
        return "\(name). \(currentValue). The graph line is \(trend). "
             + "Simulation is \(timeProgress) percent complete. "
             + "Time cursor is at \(String(format: "%.2f", currentTime)) seconds."
    }
}

// Projectile Motion

extension ProjectileMotionViewModel {

    var simulationBodyAccessibilityLabel: String {
        let pos  = currentPosition
        let vel  = currentVelocity
        let spd  = currentSpeedMagnitude
        let ang  = currentVelocityAngle
        let phase = flightPhaseDescription
        return "Projectile. Phase: \(phase). "
             + "Position: \(String(format: "%.1f", pos.x)) metres horizontal, "
             + "\(String(format: "%.1f", pos.y)) metres vertical. "
             + "Speed: \(String(format: "%.1f", spd)) metres per second "
             + "at angle \(String(format: "%.1f", ang)) degrees. "
             + "Horizontal velocity: \(String(format: "%.1f", vel.dx)) metres per second. "
             + "Vertical velocity: \(String(format: "%.1f", vel.dy)) metres per second. "
             + enhancedPhysicsInsight.explanation
    }

    var graphAccessibilityLabel: String {
        let pos = currentPosition
        let axisName = selectedAxis == .x ? "horizontal position X" : "vertical position Y"
        let currentVal = selectedAxis == .x
            ? String(format: "%.1f", pos.x)
            : String(format: "%.1f", pos.y)
        let trend: String
        if selectedAxis == .x {
            trend = "a straight rising line — horizontal velocity is constant"
        } else {
            let vy = currentVelocity.dy
            trend = vy > 1   ? "rising — projectile is still ascending"
                  : vy < -1  ? "falling — projectile is descending"
                  :             "near its peak — approaching maximum height"
        }
        return "\(axisName.capitalized) versus time graph. "
             + "Current value: \(currentVal) metres. "
             + "Graph is \(trend). "
             + "Time: \(String(format: "%.2f", currentTime)) seconds. "
             + "Flight phase: \(flightPhaseDescription)."
    }
}

// Escape Velocity

extension EscapeVelocityViewModel {

    var simulationBodyAccessibilityLabel: String {
        let ratio   = bodySpeed / surfaceEscapeVelocity
        let pct     = Int(ratio * 100)
        let outcome = hasEscaped       ? "The object has successfully escaped \(selectedBody.rawValue)." :
                      hasReachedPlanet ? "The object has fallen back to \(selectedBody.rawValue)." :
                      stateDescription

        return "Orbital body orbiting \(selectedBody.rawValue). "
             + "\(outcome) "
             + "Current speed: \(String(format: "%.2f", bodySpeed)) kilometres per second. "
             + "Escape velocity for \(selectedBody.rawValue): \(String(format: "%.1f", surfaceEscapeVelocity)) kilometres per second. "
             + "Speed is \(pct) percent of escape velocity. "
             + "Altitude: \(String(format: "%.0f", altitude)) kilometres. "
             + currentInsight
    }

    var graphAccessibilityLabel: String {
        "Speed versus escape velocity comparison for \(selectedBody.rawValue). "
        + "Your speed: \(String(format: "%.2f", bodySpeed)) km/s. "
        + "Escape velocity: \(String(format: "%.1f", surfaceEscapeVelocity)) km/s. "
        + stateDescription + ". " + currentInsight
    }
}

// MARK: - Orbital Mechanics

extension OrbitalMechanicsViewModel {

    var simulationBodyAccessibilityLabel: String {
        let orbitDesc: String
        switch orbitType {
        case .elliptical: orbitDesc = "in a bound elliptical orbit"
        case .parabolic:  orbitDesc = "on a parabolic escape trajectory"
        case .hyperbolic: orbitDesc = "on a hyperbolic escape trajectory"
        case .crashed:    orbitDesc = "crashed into the planet"
        case .undefined:  orbitDesc = "orbit not yet determined"
        }

        let energySign = totalEnergyReal < 0 ? "negative (bound orbit)" : "positive (escape trajectory)"

        return "Satellite \(orbitDesc). "
             + "Speed: \(speedDisplay). "
             + "Altitude: \(altitudeDisplay). "
             + "Orbit type: \(orbitType.rawValue). "
             + "Total energy: \(String(format: "%.1f", totalEnergyReal)) km squared per second squared, which is \(energySign). "
             + statusMessage
    }

    var selectedGraphAccessibilityLabel: String {
        let gt     = selectedGraph
        let values = gt.values(from: energyHistory)
        let latest = values.last ?? 0
        let mn     = values.min() ?? 0
        let mx     = values.max() ?? 0
        let trend: String
        if values.count < 3 {
            trend = "insufficient data — run the simulation"
        } else {
            let recent = Array(values.suffix(10))
            let avg1 = recent.prefix(5).reduce(0, +) / 5
            let avg2 = recent.suffix(5).reduce(0, +) / 5
            trend = abs(avg2 - avg1) < 0.01 * abs(mx - mn + 0.001)
                ? "stable and nearly constant — energy is conserved"
                : avg2 > avg1 ? "increasing" : "decreasing"
        }

        return "\(gt.label) versus time graph (\(gt.unit)). "
             + "Current value: \(String(format: "%.2f", latest)) \(gt.unit). "
             + "Range: \(String(format: "%.2f", mn)) to \(String(format: "%.2f", mx)) \(gt.unit). "
             + "Trend: \(trend). "
             + "Orbit type: \(orbitType.rawValue)."
    }

    var energyOverviewAccessibilityLabel: String {
        let h = energyHistory
        guard let last = h.last else {
            return "Energy overview graph. No data yet. Run the simulation to see kinetic, potential, and total energy."
        }
        let keSign  = last.ke   >= 0 ? "positive" : "negative"
        let peSign  = last.pe   >= 0 ? "positive" : "negative"
        let totSign = last.total >= 0 ? "positive, indicating escape trajectory" : "negative, indicating a bound orbit"
        return "Energy overview graph. "
             + "Kinetic energy: \(String(format: "%.1f", last.ke)) km squared per second squared, \(keSign). "
             + "Potential energy: \(String(format: "%.1f", last.pe)) km squared per second squared, \(peSign). "
             + "Total energy: \(String(format: "%.1f", last.total)) km squared per second squared, \(totSign)."
    }
}

// Segmented Graph Accessibility (Linear & Projectile)

extension SegmentedGraphView {
    func accessibilityDescription(for segments: [GraphSegment], title: String, currentTime: Double) -> String {
        let allPoints = segments.flatMap { $0.points.filter { $0.x >= $0.x && $0.x <= $0.x } }
        let ys = segments.flatMap { s in s.points.filter { $0.x >= s.startTime && $0.x <= s.endTime }.map { $0.y } }
        guard !ys.isEmpty else { return "\(title). No data yet." }
        let minY = ys.min()!
        let maxY = ys.max()!
        let segmentCount = segments.filter { $0.role == .actual }.count
        return "\(title). "
             + "Value range: \(String(format: "%.2f", minY)) to \(String(format: "%.2f", maxY)). "
             + "Number of segments: \(segmentCount). "
             + "Time cursor at \(String(format: "%.2f", currentTime)) seconds."
    }
}
