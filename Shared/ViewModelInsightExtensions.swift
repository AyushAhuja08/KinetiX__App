

import SwiftUI

extension LinearMotionViewModel {

    var enhancedPhysicsInsight: PhysicsInsightCard.InsightData {
        let a = acceleration
        let v = currentVelocity
        let d = currentDistance

        if abs(a) < 0.1 {
            return PhysicsInsightCard.InsightData(
                title: "Uniform Motion",
                icon: "arrow.right",
                color: .blue,
                explanation: "Zero acceleration means velocity is constant. The object moves at a steady \(String(format: "%.1f", v)) m/s, covering equal distances in equal time intervals.",
                formula: "v = constant, a = 0"
            )
        } else if a > 0 && v >= 0 {
            return PhysicsInsightCard.InsightData(
                title: "Accelerating Forward",
                icon: "arrow.up.right",
                color: .green,
                explanation: "Positive acceleration increases velocity. The object speeds up, covering more distance each second. Current velocity: \(String(format: "%.1f", v)) m/s.",
                formula: "a > 0 → velocity increases"
            )
        } else if a > 0 && v < 0 {
            return PhysicsInsightCard.InsightData(
                title: "Slowing Down (Backward)",
                icon: "arrow.down.backward",
                color: .orange,
                explanation: "Moving backward but accelerating forward. The object slows down and will eventually reverse direction.",
                formula: "a·v < 0 → slowing down"
            )
        } else if a < 0 && v > 0 {
            return PhysicsInsightCard.InsightData(
                title: "Decelerating Forward",
                icon: "arrow.down.forward",
                color: .orange,
                explanation: "Moving forward but accelerating backward. The object slows down and may reverse direction if deceleration continues.",
                formula: "a·v < 0 → slowing down"
            )
        } else {
            return PhysicsInsightCard.InsightData(
                title: "Accelerating Backward",
                icon: "arrow.down.left",
                color: .red,
                explanation: "Negative acceleration increases backward velocity. The object speeds up in the negative direction.",
                formula: "a < 0 → velocity becomes more negative"
            )
        }
    }


    var liveValuesData: [LiveValuesPanel.LiveValue] {
        [
            LiveValuesPanel.LiveValue(
                label: "Distance",
                value: String(format: "%.2f", currentDistance),
                icon: "ruler",
                color: .blue,
                unit: "m"
            ),
            LiveValuesPanel.LiveValue(
                label: "Velocity",
                value: String(format: "%.2f", currentVelocity),
                icon: "speedometer",
                color: .green,
                unit: "m/s"
            ),
            LiveValuesPanel.LiveValue(
                label: "Acceleration",
                value: String(format: "%.2f", acceleration),
                icon: "arrow.up.arrow.down",
                color: .orange,
                unit: "m/s²"
            )
        ]
    }


    func velocityExplanation(_ value: Double) -> String {
        if abs(value) < 0.5 {
            return "Nearly at rest. The object starts with minimal motion."
        } else if value > 0 {
            return "Positive velocity: moving forward at \(String(format: "%.1f", value)) m/s."
        } else {
            return "Negative velocity: moving backward at \(String(format: "%.1f", abs(value))) m/s."
        }
    }


    func accelerationExplanation(_ value: Double) -> String {
        if abs(value) < 0.1 {
            return "Zero acceleration: velocity remains constant (uniform motion)."
        } else if value > 0 {
            return "Positive: velocity increases by \(String(format: "%.1f", value)) m/s every second."
        } else {
            return "Negative: velocity decreases by \(String(format: "%.1f", abs(value))) m/s every second."
        }
    }
}

extension PhysicsInsightCard {
    struct InsightData {
        let title: String
        let icon: String
        let color: Color
        let explanation: String
        let formula: String
    }
}

extension ProjectileMotionViewModel {

    var enhancedPhysicsInsight: PhysicsInsightCard.InsightData {
        let vy = currentVelocity.dy
        let vx = currentVelocity.dx
        let y = currentPosition.y


        if y < 0.1 && abs(vy) < 1 {
            return PhysicsInsightCard.InsightData(
                title: "Launch/Landing Phase",
                icon: "point.bottomleft.forward.to.arrowtriangle.uturnup.scurvepath",
                color: .blue,
                explanation: "The projectile is at ground level. Launch angle and speed determine the trajectory shape and range.",
                formula: "y ≈ 0, preparing for flight"
            )
        } else if vy > 1 {
            return PhysicsInsightCard.InsightData(
                title: "Ascending Phase",
                icon: "arrow.up",
                color: .green,
                explanation: "Moving upward with vᵧ = \(String(format: "%.1f", vy)) m/s. Gravity pulls down at \(String(format: "%.1f", gravity)) m/s², slowing vertical motion.",
                formula: "vᵧ > 0 → rising, vₓ = constant"
            )
        } else if abs(vy) <= 1 {
            return PhysicsInsightCard.InsightData(
                title: "Near Apex",
                icon: "circle",
                color: .purple,
                explanation: "At maximum height! Vertical velocity ≈ 0, but horizontal velocity continues. This is the peak of the parabola.",
                formula: "vᵧ ≈ 0, vₓ ≠ 0 → apex"
            )
        } else {
            return PhysicsInsightCard.InsightData(
                title: "Descending Phase",
                icon: "arrow.down",
                color: .orange,
                explanation: "Falling with vᵧ = \(String(format: "%.1f", vy)) m/s. Gravity accelerates downward, increasing speed until landing.",
                formula: "vᵧ < 0 → falling, vₓ = constant"
            )
        }
    }


    var liveValuesData: [LiveValuesPanel.LiveValue] {
        [
            LiveValuesPanel.LiveValue(
                label: "Height",
                value: String(format: "%.2f", currentPosition.y),
                icon: "arrow.up.to.line",
                color: .green,
                unit: "m"
            ),
            LiveValuesPanel.LiveValue(
                label: "Range",
                value: String(format: "%.2f", currentPosition.x),
                icon: "arrow.right.to.line",
                color: .blue,
                unit: "m"
            ),
            LiveValuesPanel.LiveValue(
                label: "Speed",
                value: String(format: "%.2f", currentSpeedMagnitude),
                icon: "speedometer",
                color: .red,
                unit: "m/s"
            ),
            LiveValuesPanel.LiveValue(
                label: "Angle",
                value: String(format: "%.1f", currentVelocityAngle),
                icon: "angle",
                color: .purple,
                unit: "°"
            )
        ]
    }


    func speedExplanation(_ value: Double) -> String {
        if value < 10 {
            return "Low speed: short range, quick landing. Like a gentle toss."
        } else if value < 20 {
            return "Medium speed: balanced trajectory. Good for observing parabolic motion."
        } else {
            return "High speed: long range, extended flight time. Maximum distance!"
        }
    }


    func angleExplanation(_ value: Double) -> String {
        if value < 20 {
            return "Low angle: long, flat trajectory. Maximizes range over height."
        } else if value < 40 {
            return "Medium-low angle: balanced but range-focused trajectory."
        } else if abs(value - 45) < 5 {
            return "45° angle: theoretically maximum range for given speed!"
        } else if value < 60 {
            return "Medium-high angle: balanced but height-focused trajectory."
        } else {
            return "High angle: steep, tall trajectory. Maximizes height over range."
        }
    }


    var flightPhaseDescription: String {
        let vy = currentVelocity.dy
        let y = currentPosition.y

        if y < 0.1 {
            return "Ground Level"
        } else if vy > 1 {
            return "Ascending ↑"
        } else if abs(vy) <= 1 && y > 0.1 {
            return "At Apex ●"
        } else {
            return "Descending ↓"
        }
    }
}
