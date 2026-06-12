

import SwiftUI
import Observation

enum CelestialBody: String, CaseIterable {
    case earth = "Earth"
    case moon = "Moon"
    case mars = "Mars"

    var mass: Double {
        switch self {
        case .earth: return 5.97e24
        case .moon: return 7.34e22
        case .mars: return 6.39e23
        }
    }

    var radius: Double {
        switch self {
        case .earth: return 6371.0
        case .moon: return 1737.0
        case .mars: return 3390.0
        }
    }

    var surfaceEscapeVelocity: Double {
        switch self {
        case .earth: return 11.2
        case .moon: return 2.4
        case .mars: return 5.0
        }
    }

    var color: Color {
        switch self {
        case .earth: return .blue
        case .moon: return .gray
        case .mars: return .red
        }
    }

    var secondaryColor: Color {
        switch self {
        case .earth: return .cyan
        case .moon: return Color(white: 0.6)
        case .mars: return .orange
        }
    }

    var icon: String {
        switch self {
        case .earth: return "globe.americas.fill"
        case .moon: return "moon.fill"
        case .mars: return "circle.fill"
        }
    }
}

enum OrbitalState {
    case stable
    case escaping
    case decaying
}

struct OrbitChangeEvent: Identifiable {
    let id = UUID()
    let time: Double
    let speedBefore: Double
    let speedAfter: Double
    let state: OrbitalState
    let orbitRadius: Double
    let planetName: String
    let escapeVelocity: Double

    var headline: String {
        let diff = speedAfter - speedBefore
        return diff > 0
            ? String(format: "↑ Speed increased  %.1f → %.1f km/s", speedBefore, speedAfter)
            : String(format: "↓ Speed decreased  %.1f → %.1f km/s", speedBefore, speedAfter)
    }

    var physicsExplanation: String {
        let ev = escapeVelocity
        let v  = speedAfter
        let ratio = ev > 0 ? v / ev : 0

        if v >= ev {
            return """
Your speed (\(String(format: "%.2f", v)) km/s) meets or exceeds escape velocity (\(String(format: "%.1f", ev)) km/s).

Total mechanical energy E = ½v² - GM/r is now ≥ 0.

The object has enough kinetic energy to overcome all gravitational potential energy and still have speed left at infinity. It will never return to \(planetName).

Formula: v_escape = √(2GM/r)
At altitude \(String(format: "%.0f", orbitRadius)) km above \(planetName), escape requires exactly \(String(format: "%.2f", ev)) km/s.

Your ratio: \(String(format: "%.2f", ratio))× escape velocity.
"""
        } else {
            let deficit = ev - v
            return """
Your speed (\(String(format: "%.2f", v)) km/s) is below escape velocity (\(String(format: "%.1f", ev)) km/s) by \(String(format: "%.2f", deficit)) km/s.

Total mechanical energy E = ½v² - GM/r is negative → bound trajectory.

The object does not have enough kinetic energy to overcome gravity. It will slow down, stop at a maximum altitude, then fall back toward \(planetName).

Formula: v_escape = √(2GM/r)
You are at \(String(format: "%.0f", ratio * 100))% of escape velocity.

To escape: you need \(String(format: "%.2f", deficit)) km/s more speed.
"""
        }
    }

    var paramIcon: String { "speedometer" }
    var paramColor: Color { speedAfter >= escapeVelocity ? .blue : .orange }
    var changedParameter: String { "Body Speed" }
}

@Observable
class EscapeVelocityViewModel {

    var selectedBody: CelestialBody = .earth {
        didSet {
            let old = oldValue
            changeEvents.append(OrbitChangeEvent(
                time: currentTime,
                speedBefore: bodySpeed,
                speedAfter: bodySpeed,
                state: orbitalState,
                orbitRadius: altitude,
                planetName: selectedBody.rawValue,
                escapeVelocity: selectedBody.surfaceEscapeVelocity
            ))
            reset()
        }
    }


    let planetRadius: Double = 50.0
    let G: Double = 6.674e-11


    var altitude: Double = 400.0
    var bodySpeed: Double = 7.0
    var currentAngle: Double = 0.0
    var isPlaying: Bool = false
    var manualTime: Double = 0.0 { didSet { currentTime = manualTime } }
    var currentTime: Double = 0.0


    var orbitalState: OrbitalState = .stable
    var changeEvents: [OrbitChangeEvent] = []
    var hasReachedPlanet: Bool = false
    var hasEscaped: Bool = false


    private var timer: Timer?
    private let maxTime: Double = 30.0
    private var angularVelocity: Double = 0.0
    private var radialVelocity: Double = 0.0


    var orbitRadius: Double {

        let visualScale = 150.0 / 400.0
        return planetRadius + altitude * visualScale
    }


    var planetMass: Double { selectedBody.mass }
    var planetActualRadius: Double { selectedBody.radius }
    var surfaceEscapeVelocity: Double { selectedBody.surfaceEscapeVelocity }
    var planetColor: Color { selectedBody.color }
    var planetSecondaryColor: Color { selectedBody.secondaryColor }







    var currentEscapeVelocity: Double {

        let r = (planetActualRadius + altitude) * 1000


        let vEscape = sqrt(2 * G * planetMass / r) / 1000
        return vEscape
    }





    var orbitalVelocity: Double {

        let r = (planetActualRadius + altitude) * 1000


        let vOrbit = sqrt(G * planetMass / r) / 1000
        return vOrbit
    }

    var currentSpeedRatio: Double {
        bodySpeed / surfaceEscapeVelocity
    }

    var orbitalSpeedRatio: Double {
        bodySpeed / orbitalVelocity
    }

    init() {
        updateOrbitalState()
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
        currentAngle = 0
        hasReachedPlanet = false
        hasEscaped = false
        altitude = 400.0
        updateOrbitalState()
    }

    func setBodySpeed(_ newSpeed: Double) {
        let oldSpeed = bodySpeed
        bodySpeed = newSpeed

        let oldState = orbitalState
        updateOrbitalState()


        if abs(oldSpeed - newSpeed) > 0.1 {
            changeEvents.append(OrbitChangeEvent(
                time: currentTime,
                speedBefore: oldSpeed,
                speedAfter: newSpeed,
                state: orbitalState,
                orbitRadius: altitude,
                planetName: selectedBody.rawValue,
                escapeVelocity: surfaceEscapeVelocity
            ))
        }


        if oldState != orbitalState {
            hasReachedPlanet = false
            hasEscaped = false
            Haptics.thresholdCrossed()
        }
    }

    var currentInsight: String {
        let planetName = selectedBody.rawValue
        let escVel = surfaceEscapeVelocity
        switch orbitalState {
        case .stable:
            return "Right at escape velocity! Barely breaking free 🚀"
        case .escaping:
            return String(format: "Speed ≥ %.1f km/s → Escaping %@ forever! 🚀", escVel, planetName)
        case .decaying:
            return String(format: "Speed < %.1f km/s → Falling back to %@ 📉", escVel, planetName)
        }
    }

    var stateDescription: String {
        switch orbitalState {
        case .stable:
            return "At Escape Velocity"
        case .escaping:
            return "Escaping!"
        case .decaying:
            return "Falling Back"
        }
    }

    var stateColor: Color {
        switch orbitalState {
        case .stable:
            return .green
        case .escaping:
            return .blue
        case .decaying:
            return .orange
        }
    }



    private func updateOrbitalState() {





        let escapeVel = surfaceEscapeVelocity

        if bodySpeed >= escapeVel {

            orbitalState = .escaping
        } else {

            orbitalState = .decaying
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self else { return }

            self.currentTime += 0.03
            self.manualTime = self.currentTime


            switch self.orbitalState {
            case .stable:
                self.updateStableOrbit(dt: 0.03)

            case .escaping:
                self.updateEscapingOrbit(dt: 0.03)

            case .decaying:
                self.updateDecayingOrbit(dt: 0.03)
            }

            if self.currentTime >= self.maxTime {
                self.reset()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateStableOrbit(dt: Double) {


        angularVelocity = bodySpeed * 0.5
        currentAngle += angularVelocity * dt


        while currentAngle > 2 * .pi {
            currentAngle -= 2 * .pi
        }
    }

    private func updateEscapingOrbit(dt: Double) {
        if hasEscaped {
            return
        }



        angularVelocity = bodySpeed * 0.5


        currentAngle += angularVelocity * dt


        while currentAngle > 2 * .pi {
            currentAngle -= 2 * .pi
        }


        let escapeRate = (bodySpeed - orbitalVelocity) * 50.0
        altitude += escapeRate * dt



        if orbitRadius > 250 {
            hasEscaped = true
            stopTimer()
            Haptics.escape()
        }
    }

    private func updateDecayingOrbit(dt: Double) {
        if hasReachedPlanet {
            return
        }



        angularVelocity = bodySpeed * 0.5


        currentAngle += angularVelocity * dt


        while currentAngle > 2 * .pi {
            currentAngle -= 2 * .pi
        }


        let decayRate = (surfaceEscapeVelocity - bodySpeed) * 30.0
        altitude -= decayRate * dt


        if altitude <= 0 {
            hasReachedPlanet = true
            altitude = 0
            stopTimer()
            Haptics.crash()
        }
    }
}
