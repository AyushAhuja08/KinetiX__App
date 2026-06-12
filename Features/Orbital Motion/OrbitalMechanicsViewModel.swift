

import SwiftUI
import Combine
import Observation

struct Vector2D {
    var x: Double
    var y: Double

    static let zero = Vector2D(x: 0, y: 0)

    var magnitude: Double { sqrt(x * x + y * y) }
    var magnitudeSquared: Double { x * x + y * y }

    var normalized: Vector2D {
        let m = magnitude
        guard m > 0 else { return .zero }
        return Vector2D(x: x / m, y: y / m)
    }

    static func + (l: Vector2D, r: Vector2D) -> Vector2D { Vector2D(x: l.x + r.x, y: l.y + r.y) }
    static func - (l: Vector2D, r: Vector2D) -> Vector2D { Vector2D(x: l.x - r.x, y: l.y - r.y) }
    static func * (v: Vector2D, s: Double) -> Vector2D { Vector2D(x: v.x * s, y: v.y * s) }
    static func * (s: Double, v: Vector2D) -> Vector2D { Vector2D(x: v.x * s, y: v.y * s) }

    func dot(_ other: Vector2D) -> Double { x * other.x + y * other.y }
}

enum OrbitType: String {
    case elliptical = "Elliptical (Bound)"
    case parabolic  = "Parabolic"
    case hyperbolic = "Hyperbolic (Escape)"
    case crashed    = "Crashed!"
    case undefined  = "—"

    var color: Color {
        switch self {
        case .elliptical: return .cyan
        case .parabolic:  return .yellow
        case .hyperbolic: return .orange
        case .crashed:    return .red
        case .undefined:  return .gray
        }
    }

    var icon: String {
        switch self {
        case .elliptical: return "ellipsis.circle"
        case .parabolic:  return "target"
        case .hyperbolic: return "arrow.up.forward"
        case .crashed:    return "exclamationmark.triangle.fill"
        case .undefined:  return "questionmark.circle"
        }
    }
}

enum IntegratorType: String, CaseIterable {
    case symplecticEuler = "Semi-Implicit Euler"
    case velocityVerlet  = "Velocity Verlet"
}

enum OrbitalPreset: String, CaseIterable {
    case earth  = "Earth"
    case moon   = "Moon"
    case mars   = "Mars"
    case custom = "Custom"


    var simMass: Double {
        switch self {
        case .earth:  return 1200.0
        case .moon:   return 200.0
        case .mars:   return 800.0
        case .custom: return 1000.0
        }
    }

    var simPlanetRadius: Double {
        switch self {
        case .earth:  return 30.0
        case .moon:   return 18.0
        case .mars:   return 24.0
        case .custom: return 25.0
        }
    }

    var simStartRadius: Double {
        switch self {
        case .earth:  return 120.0
        case .moon:   return 80.0
        case .mars:   return 100.0
        case .custom: return 110.0
        }
    }


    var simCircularSpeed: Double { sqrt(simMass / simStartRadius) }





    var realMassKg: Double {
        switch self {
        case .earth:  return 5.972e24
        case .moon:   return 7.342e22
        case .mars:   return 6.390e23
        case .custom: return 1.000e24
        }
    }


    var realPlanetRadiusKm: Double {
        switch self {
        case .earth:  return 6_371.0
        case .moon:   return 1_737.4
        case .mars:   return 3_389.5
        case .custom: return 5_000.0
        }
    }


    var realOrbitAltitudeKm: Double {
        switch self {
        case .earth:  return 400.0
        case .moon:   return 100.0
        case .mars:   return 300.0
        case .custom: return 350.0
        }
    }


    var realOrbitRadiusKm: Double {
        realPlanetRadiusKm + realOrbitAltitudeKm
    }


    private static let G_real: Double = 6.674e-11

    var realCircularSpeedKmS: Double {
        let r = realOrbitRadiusKm * 1_000
        return sqrt(OrbitalPreset.G_real * realMassKg / r) / 1_000
    }

    var realEscapeSpeedKmS: Double {
        realCircularSpeedKmS * sqrt(2.0)
    }

    var realSurfaceEscapeSpeedKmS: Double {
        let r = realPlanetRadiusKm * 1_000
        return sqrt(2 * OrbitalPreset.G_real * realMassKg / r) / 1_000
    }




    var kmPerSimUnit: Double { realOrbitRadiusKm / simStartRadius }



    var kmSPerSimSpeed: Double {
        guard simCircularSpeed > 0 else { return 1 }
        return realCircularSpeedKmS / simCircularSpeed
    }


    var color: Color {
        switch self {
        case .earth:  return .blue
        case .moon:   return .gray
        case .mars:   return .red
        case .custom: return .purple
        }
    }

    var icon: String {
        switch self {
        case .earth:  return "globe.americas.fill"
        case .moon:   return "moon.fill"
        case .mars:   return "circle.fill"
        case .custom: return "slider.horizontal.3"
        }
    }

    var description: String {
        switch self {
        case .earth:
            return "M = 5.97×10²⁴ kg  •  R = 6,371 km  •  ISS orbit (+400 km)"
        case .moon:
            return "M = 7.34×10²² kg  •  R = 1,737 km  •  Low lunar orbit (+100 km)"
        case .mars:
            return "M = 6.39×10²³ kg  •  R = 3,390 km  •  Low Mars orbit (+300 km)"
        case .custom:
            return "Custom parameters — adjust mass, radius, and altitude freely"
        }
    }
}

struct EnergyEntry {
    let time: Double
    let ke: Double
    let pe: Double
    let total: Double
    let radius: Double
}

enum ChangedParameter: String {
    case speed      = "Launch Speed"
    case angle      = "Launch Angle"
    case altitude   = "Orbit Altitude"
    case mass       = "Planet Mass"
    case preset     = "Preset"
    case integrator = "Integrator"
}

struct OrbitalParameterChange: Identifiable {
    let id = UUID()
    let parameter: ChangedParameter
    let oldValue: String
    let newValue: String
    let orbitTypeBefore: OrbitType
    let circularSpeedKmS: Double
    let escapeSpeedKmS: Double

    let newSpeedKmS: Double

    var headline: String {
        switch parameter {
        case .speed:
            let oldD = Double(oldValue.replacingOccurrences(of: " km/s", with: "")) ?? 0
            let newD = Double(newValue.replacingOccurrences(of: " km/s", with: "")) ?? 0
            return newD > oldD
                ? "↑ Launch speed increased  \(oldValue) → \(newValue)"
                : "↓ Launch speed decreased  \(oldValue) → \(newValue)"
        case .angle:
            return "↻ Launch angle changed  \(oldValue)° → \(newValue)°"
        case .altitude:
            return "↕ Orbit altitude changed  \(oldValue) km → \(newValue) km"
        case .mass:
            return "⚖ Planet mass changed  \(oldValue) → \(newValue)"
        case .preset:
            return "🌍 Preset switched  \(oldValue) → \(newValue)"
        case .integrator:
            return "⚙ Integrator switched  \(oldValue) → \(newValue)"
        }
    }

    var physicsExplanation: String {
        switch parameter {
        case .speed:
            let v    = newSpeedKmS
            let vc   = circularSpeedKmS
            let ve   = escapeSpeedKmS
            let ratio = vc > 0 ? v / vc : 0
            if v < vc * 0.95 {
                return """
Your speed (\(newValue)) is below the circular orbit speed (\(String(format: "%.2f km/s", vc))).

Gravity is stronger than the centripetal acceleration needed to maintain orbit. The satellite dips inward — it cannot "keep missing" the planet. This is a sub-orbital trajectory that ends in a crash.

Think of it like throwing a ball not quite hard enough to reach orbit. It arcs upward, slows, and falls back.
"""
            } else if v <= vc * 1.05 {
                return """
Your speed (\(newValue)) ≈ circular orbit speed (\(String(format: "%.2f km/s", vc))).

At this speed, gravitational force exactly equals the centripetal force needed:
  GMm/r² = mv²/r  →  v = √(GM/r)

The satellite's path curves at the same rate as the planet's surface — it continuously falls but keeps missing. This is a stable circular orbit.
"""
            } else if v < ve * 0.99 {
                return """
Your speed (\(newValue)) is between circular (\(String(format: "%.2f", vc)) km/s) and escape (\(String(format: "%.2f", ve)) km/s) — that's \(String(format: "%.2f", ratio))× circular speed.

Total energy is negative (bound orbit) but greater than the circular case — the extra energy stretches the orbit into an ellipse. The satellite swings out to a higher apoapsis then falls back.

This is exactly how all real planetary and satellite orbits work. The ISS, Moon, and every planet follow elliptical paths.
"""
            } else if v <= ve * 1.05 {
                return """
Your speed (\(newValue)) ≈ escape velocity (\(String(format: "%.2f km/s", ve))).

Total mechanical energy = 0:
  ½v² - GM/r = 0  →  v = √(2GM/r)

The satellite just barely reaches infinite distance with zero speed remaining. This is a parabolic trajectory — the mathematical boundary between bound and unbound motion.
"""
            } else {
                return """
Your speed (\(newValue)) exceeds escape velocity (\(String(format: "%.2f km/s", ve))).

Total energy is positive — kinetic energy exceeds everything gravity can absorb. The satellite escapes on a hyperbolic path and has leftover speed even at infinite distance:
  v∞ = √(v² - v_escape²)

Real examples: Voyager 1 & 2 achieved hyperbolic escape from the Solar System.
"""
            }

        case .angle:
            let deg = Double(newValue) ?? 0
            if abs(deg - 90) < 5 {
                return """
90° = velocity is purely tangential (perpendicular to the radius vector).

This is ideal for a circular orbit — 100% of your launch speed becomes orbital speed. No component is wasted pushing toward or away from the planet.

Real rocket launches aim for tangential velocity after reaching altitude — this is called the "gravity turn."
"""
            } else if deg < 90 {
                return """
\(String(format: "%.0f", deg))° points partly toward the planet.

The radial (inward) component: v_r = \(newValue) × sin(\(String(format: "%.0f", 90 - deg))°) is wasted fighting gravity. The effective tangential speed is lower, so the orbit's closest point (periapsis) dips lower. An extreme inward angle causes a crash.
"""
            } else {
                return """
\(String(format: "%.0f", deg))° points partly away from the planet.

The radial (outward) component lifts the apoapsis — the satellite's farthest point. The orbit becomes elongated. At extreme angles (near 270°) the launch is almost directly away from the planet, creating a very eccentric ellipse or escape trajectory.
"""
            }

        case .altitude:
            return """
Orbit altitude = \(newValue) km above the surface.

At this altitude:
  • Circular speed = \(String(format: "%.2f km/s", circularSpeedKmS))  (v = √(GM/r))
  • Escape speed   = \(String(format: "%.2f km/s", escapeSpeedKmS))   (v = √(2GM/r))

Higher altitude → weaker gravity (∝ 1/r²) → lower orbital and escape speeds. The ISS at 400 km needs 7.66 km/s; a satellite at 36,000 km (geostationary) only needs 3.07 km/s.
"""

        case .mass:
            let earthEquiv = (Double(newValue.replacingOccurrences(of: " M⊕", with: "")) ?? 1.0)
            return """
Planet mass changed to \(newValue) (\(String(format: "%.2f", earthEquiv))× Earth's mass).

Both circular and escape speeds scale with √M:
  v_circ ∝ √M  →  now \(String(format: "%.2f km/s", circularSpeedKmS))
  v_esc  ∝ √M  →  now \(String(format: "%.2f km/s", escapeSpeedKmS))

A heavier planet pulls harder — you need more speed to maintain orbit and even more to escape.
Real examples:
  • Earth (1.00 M⊕)  → circular ≈ 7.66 km/s, escape ≈ 11.19 km/s
  • Moon  (0.01 M⊕)  → circular ≈ 1.63 km/s, escape ≈  2.38 km/s
  • Mars  (0.11 M⊕)  → circular ≈ 3.41 km/s, escape ≈  5.03 km/s
"""

        case .preset:
            return """
\(newValue) selected.

Real values:
  • Circular orbit speed ≈ \(String(format: "%.2f km/s", circularSpeedKmS))
  • Escape speed ≈ \(String(format: "%.2f km/s", escapeSpeedKmS))

The physics simulation runs in normalised units (G=1) for numerical stability, but all displayed speeds, distances, and energies are converted to real km/s and km using the true physical constants for \(newValue).
"""

        case .integrator:
            if newValue == "Velocity Verlet" {
                return """
Switched to Velocity Verlet.

This integrator evaluates force at both the start AND end of each step, then averages them for the velocity update:
  x += v·dt + ½·a·dt²
  a_new = F(x_new)/m
  v += ½·(a_old + a_new)·dt

Result: 2nd-order accuracy — halving dt cuts error by 4× instead of 2×. Time-reversible and symplectic. Watch the Total Energy graph stay flatter than Semi-Implicit Euler.
"""
            } else {
                return """
Switched to Semi-Implicit Euler.

A minimal change to standard Euler: velocity is updated first, then position uses the NEW velocity:
  v += a·dt
  x += v_new·dt   ← this is what makes it symplectic

This preserves a "shadow" energy, preventing orbits from slowly spiraling in or out. 1 force evaluation per step — fast and stable for long runs.
"""
            }
        }
    }
}

private let G_SIM: Double    = 1.0
private let DT: Double       = 0.005
private let SUBSTEPS: Int    = 8
private let MAX_TRAIL: Int   = 600
private let MAX_GRAPH: Int   = 400
private let PARABOLIC_EPS: Double = 0.5
private let MAX_SIM_RADIUS: Double = 800.0

@Observable
@MainActor
class OrbitalMechanicsViewModel {


    private(set) var simPosition: Vector2D = .zero
    private(set) var simVelocity: Vector2D = .zero
    private(set) var simAcceleration: Vector2D = .zero


    private(set) var orbitType: OrbitType = .undefined


    private(set) var kineticEnergyReal: Double  = 0
    private(set) var potentialEnergyReal: Double = 0
    private(set) var totalEnergyReal: Double     = 0


    private(set) var trail: [Vector2D] = []
    private(set) var energyHistory: [EnergyEntry] = []
    private(set) var simTime: Double = 0
    private(set) var isRunning: Bool = false
    private(set) var hasCrashed: Bool = false
    private(set) var hasEscaped: Bool = false


    var parameterChanges: [OrbitalParameterChange] = []
    private let maxChanges = 20


    var showVelocityVector:     Bool = true
    var showAccelerationVector: Bool = false
    var showGravityVector:      Bool = false
    var showTrail:              Bool = true


    var selectedGraph: OrbitalGraphType = .totalEnergy


    var integrator: IntegratorType = .symplecticEuler {
        didSet {
            guard oldValue != integrator else { return }
            recordChange(.integrator,
                         old: oldValue.rawValue,
                         new: integrator.rawValue,
                         newSpeedKmS: realSpeedKmS)
        }
    }


    var preset: OrbitalPreset = .earth {
        didSet {
            guard oldValue != preset else { return }
            let before = oldValue.rawValue
            applyPreset()
            recordChange(.preset, old: before, new: preset.rawValue, newSpeedKmS: realCircularSpeedKmS)
        }
    }



    var simLaunchSpeed:    Double = 0
    var launchAngleDeg:    Double = 90.0
    var simOrbitRadius:    Double = 120.0



    var simPlanetMass:     Double = 1200.0
    var simPlanetRadius:   Double = 30.0


    private var prevAcceleration: Vector2D = .zero
    private var timer: AnyCancellable?



    init() {
        applyPreset()
    }






    var kmPerSimUnit: Double { preset.kmPerSimUnit }


    var kmSPerSimSpeed: Double { preset.kmSPerSimSpeed }


    var realPositionKm: Vector2D {
        Vector2D(x: simPosition.x * kmPerSimUnit,
                 y: simPosition.y * kmPerSimUnit)
    }


    var realSpeedKmS: Double { simVelocity.magnitude * kmSPerSimSpeed }


    var realCircularSpeedKmS: Double {
        let simCirc = sqrt(G_SIM * simPlanetMass / simOrbitRadius)
        return simCirc * kmSPerSimSpeed
    }


    var realEscapeSpeedKmS: Double { realCircularSpeedKmS * sqrt(2.0) }


    var realOrbitRadiusKm: Double { simPosition.magnitude * kmPerSimUnit }


    var realAltitudeKm: Double {
        max(0, (simPosition.magnitude - simPlanetRadius) * kmPerSimUnit)
    }


    var speedDisplay:       String { String(format: "%.2f km/s", realSpeedKmS) }
    var circularDisplay:    String { String(format: "%.2f km/s", realCircularSpeedKmS) }
    var escapeDisplay:      String { String(format: "%.2f km/s", realEscapeSpeedKmS) }
    var altitudeDisplay:    String { String(format: "%.0f km", realAltitudeKm) }
    var radiusDisplay:      String { String(format: "%.0f km", realOrbitRadiusKm) }
    var launchSpeedDisplay: String { String(format: "%.2f km/s", simLaunchSpeed * kmSPerSimSpeed) }


    var surfaceEscapeDisplay: String {
        String(format: "%.2f km/s", preset.realSurfaceEscapeSpeedKmS)
    }





    func applyPreset() {
        simPlanetMass   = preset.simMass
        simPlanetRadius = preset.simPlanetRadius
        simOrbitRadius  = preset.simStartRadius
        simLaunchSpeed  = preset.simCircularSpeed
        launchAngleDeg  = 90.0
        resetSimulation()
    }





    func resetSimulation() {
        stop()
        hasCrashed = false
        hasEscaped = false
        simTime    = 0
        trail      = []
        energyHistory = []
        orbitType  = .undefined


        simPosition = Vector2D(x: simOrbitRadius, y: 0)


        let vAngle = launchAngleDeg * .pi / 180.0
        simVelocity = Vector2D(
            x: simLaunchSpeed * cos(vAngle),
            y: simLaunchSpeed * sin(vAngle)
        )

        simAcceleration = computeAcceleration(pos: simPosition)
        prevAcceleration = simAcceleration
        updateEnergies()
        classifyOrbit()
    }

    func start() {
        guard !isRunning && !hasCrashed && !hasEscaped else { return }
        isRunning = true
        timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.step() }
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }

    func toggleRunning() { isRunning ? stop() : start() }





    private func step() {
        for _ in 0..<SUBSTEPS {
            integrate()
            simTime += DT
        }
        updateEnergies()
        appendTrail()
        appendGraph()
        classifyOrbit()
        checkBoundaries()
    }

    private func integrate() {
        switch integrator {
        case .symplecticEuler:
            simVelocity     = simVelocity + simAcceleration * DT
            simPosition     = simPosition + simVelocity    * DT
            simAcceleration = computeAcceleration(pos: simPosition)

        case .velocityVerlet:
            let dtSq = DT * DT
            simPosition     = simPosition + simVelocity * DT + simAcceleration * (0.5 * dtSq)
            let newAccel    = computeAcceleration(pos: simPosition)
            simVelocity     = simVelocity + (simAcceleration + newAccel) * (0.5 * DT)
            prevAcceleration = simAcceleration
            simAcceleration = newAccel
        }
    }

    private func computeAcceleration(pos: Vector2D) -> Vector2D {
        let r = pos.magnitude
        guard r > 0 else { return .zero }
        let scale = -G_SIM * simPlanetMass / (r * r * r)
        return pos * scale
    }





    private func updateEnergies() {

        let v2_sim = simVelocity.magnitudeSquared
        let r_sim  = simPosition.magnitude
        let ke_sim = 0.5 * v2_sim
        let pe_sim = r_sim > 0 ? -G_SIM * simPlanetMass / r_sim : 0


        let s2 = kmSPerSimSpeed * kmSPerSimSpeed
        kineticEnergyReal  =  ke_sim * s2
        potentialEnergyReal = pe_sim * s2
        totalEnergyReal     = kineticEnergyReal + potentialEnergyReal
    }





    private func classifyOrbit() {
        if hasCrashed { orbitType = .crashed;    return }
        if hasEscaped { orbitType = .hyperbolic; return }


        let v2 = simVelocity.magnitudeSquared
        let r  = simPosition.magnitude
        let e  = 0.5 * v2 - G_SIM * simPlanetMass / r

        if      e < -PARABOLIC_EPS { orbitType = .elliptical }
        else if e <=  PARABOLIC_EPS { orbitType = .parabolic  }
        else                        { orbitType = .hyperbolic }
    }

    private func checkBoundaries() {
        let r = simPosition.magnitude
        if r <= simPlanetRadius {
            hasCrashed = true; stop(); orbitType = .crashed
            Haptics.crash()
        } else if r > MAX_SIM_RADIUS {
            hasEscaped = true; stop(); orbitType = .hyperbolic
            Haptics.escape()
        }
    }





    private func appendTrail() {
        trail.append(simPosition)
        if trail.count > MAX_TRAIL { trail.removeFirst(trail.count - MAX_TRAIL) }
    }

    private func appendGraph() {
        let entry = EnergyEntry(
            time:   simTime,
            ke:     kineticEnergyReal,
            pe:     potentialEnergyReal,
            total:  totalEnergyReal,
            radius: realOrbitRadiusKm
        )
        energyHistory.append(entry)
        if energyHistory.count > MAX_GRAPH {
            energyHistory.removeFirst(energyHistory.count - MAX_GRAPH)
        }
    }





    var statusMessage: String {
        if hasCrashed { return "Satellite crashed into the planet!" }
        if hasEscaped { return "Satellite has escaped gravity!" }
        return orbitType.rawValue
    }





    func recordChange(_ param: ChangedParameter, old: String, new: String, newSpeedKmS: Double) {
        let change = OrbitalParameterChange(
            parameter:         param,
            oldValue:          old,
            newValue:          new,
            orbitTypeBefore:   orbitType,
            circularSpeedKmS:  realCircularSpeedKmS,
            escapeSpeedKmS:    realEscapeSpeedKmS,
            newSpeedKmS:       newSpeedKmS
        )
        parameterChanges.insert(change, at: 0)
        if parameterChanges.count > maxChanges {
            parameterChanges = Array(parameterChanges.prefix(maxChanges))
        }
    }

    func trackSpeed(fromSimSpeed old: Double) {
        guard abs(simLaunchSpeed - old) > 0.01 else { return }
        let oldKmS = old * kmSPerSimSpeed
        let newKmS = simLaunchSpeed * kmSPerSimSpeed
        recordChange(.speed,
                     old: String(format: "%.2f km/s", oldKmS),
                     new: String(format: "%.2f km/s", newKmS),
                     newSpeedKmS: newKmS)
    }

    func trackAngle(from old: Double) {
        guard abs(launchAngleDeg - old) > 0.5 else { return }
        recordChange(.angle,
                     old: String(format: "%.0f", old),
                     new: String(format: "%.0f", launchAngleDeg),
                     newSpeedKmS: realSpeedKmS)
    }

    func trackAltitude(fromSimRadius old: Double) {
        guard abs(simOrbitRadius - old) > 0.5 else { return }
        let oldKm = max(0, (old - simPlanetRadius) * kmPerSimUnit)
        let newKm = realAltitudeKm
        recordChange(.altitude,
                     old: String(format: "%.0f", oldKm),
                     new: String(format: "%.0f", newKm),
                     newSpeedKmS: realCircularSpeedKmS)
    }

    func trackMass(fromSimMass old: Double) {
        guard abs(simPlanetMass - old) > 0.5 else { return }
        let oldEarth = old / 1200.0
        let newEarth = simPlanetMass / 1200.0
        recordChange(.mass,
                     old: String(format: "%.2f M⊕", oldEarth),
                     new: String(format: "%.2f M⊕", newEarth),
                     newSpeedKmS: realCircularSpeedKmS)
    }
}

enum OrbitalGraphType: String, CaseIterable {
    case kineticEnergy   = "KE"
    case potentialEnergy = "PE"
    case totalEnergy     = "Total E"
    case radius          = "Radius"

    var color: Color {
        switch self {
        case .kineticEnergy:   return .orange
        case .potentialEnergy: return .blue
        case .totalEnergy:     return .cyan
        case .radius:          return .green
        }
    }

    var unit: String {
        switch self {
        case .kineticEnergy, .potentialEnergy, .totalEnergy: return "km²/s²"
        case .radius: return "km"
        }
    }

    var label: String { rawValue }

    func values(from history: [EnergyEntry]) -> [Double] {
        history.map {
            switch self {
            case .kineticEnergy:   return $0.ke
            case .potentialEnergy: return $0.pe
            case .totalEnergy:     return $0.total
            case .radius:          return $0.radius
            }
        }
    }
}
