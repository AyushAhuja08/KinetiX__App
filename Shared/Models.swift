

import Foundation

enum ViewSelector: String, CaseIterable {
    case visualize = "Visualize"
    case learn = "Learn"
}

enum GraphType {
    case distance, velocity, acceleration

    var title: String {
        switch self {
        case .distance: return "Distance-Time"
        case .velocity: return "Velocity-Time"
        case .acceleration: return "Acceleration-Time"
        }
    }

    var yLabel: String {
        switch self {
        case .distance: return "Distance (m)"
        case .velocity: return "Velocity (m/s)"
        case .acceleration: return "Accel (m/s²)"
        }
    }
}

enum ProjectileAxis {
    case x, y
}
