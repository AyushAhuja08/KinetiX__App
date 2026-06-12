

import SwiftUI

extension EscapeVelocityViewModel {



    var altitudePoints: [CGPoint] {

        var points: [CGPoint] = []
        let timeInterval = 0.1

        for i in 0..<Int(10.0 / timeInterval) {
            let t = Double(i) * timeInterval
            let alt = calculateAltitudeAtTime(t)
            points.append(CGPoint(x: t, y: alt))
        }

        return points
    }


    var velocityPoints: [CGPoint] {
        var points: [CGPoint] = []
        let timeInterval = 0.1

        for i in 0..<Int(10.0 / timeInterval) {
            let t = Double(i) * timeInterval
            let vel = calculateVelocityAtTime(t)
            points.append(CGPoint(x: t, y: vel))
        }

        return points
    }


    var distancePoints: [CGPoint] {
        var points: [CGPoint] = []
        let timeInterval = 0.1

        for i in 0..<Int(10.0 / timeInterval) {
            let t = Double(i) * timeInterval
            let dist = planetActualRadius + calculateAltitudeAtTime(t)
            points.append(CGPoint(x: t, y: dist))
        }

        return points
    }



    private func calculateAltitudeAtTime(_ t: Double) -> Double {
        switch orbitalState {
        case .escaping:

            return altitude + bodySpeed * t * 50 * (1 + t * 0.1)

        case .decaying:

            let decayRate = 0.15
            return max(0, altitude * exp(-decayRate * t))

        case .stable:

            return altitude + sin(t * 0.5) * 20
        }
    }

    private func calculateVelocityAtTime(_ t: Double) -> Double {
        switch orbitalState {
        case .escaping:

            let gravDecel = (G * planetMass) / pow((planetActualRadius + altitude) * 1000, 2) / 1000
            return max(surfaceEscapeVelocity, bodySpeed - gravDecel * t * 10)

        case .decaying:

            return max(0, bodySpeed * (1 - t * 0.08))

        case .stable:

            return surfaceEscapeVelocity + sin(t) * 0.5
        }
    }
}
