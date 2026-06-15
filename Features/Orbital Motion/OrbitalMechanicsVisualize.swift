

import SwiftUI

struct OrbitalMechanicsVisualizeView: View {
    var viewModel: OrbitalMechanicsViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedGraphTab: String = "Total E"

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TitledCard(
                    title: "Simulation",
                    description: "Watch the satellite orbit the planet. Use play, pause, and reset to control time. Turn on velocity, acceleration, or gravity vectors and the orbit trail in display options below."
                ) {
                    OrbitalSimulationPanel(viewModel: viewModel)
                }

                // Horizontal swipable row for parameters and combined graphs
                if isRegular {
                    HStack(alignment: .top, spacing: 16) {
                        TitledCard(
                            title: "Adjust Parameters",
                            description: "Adjust launch speed, angle, altitude, and planet mass to see how the orbit changes."
                        ) {
                            OrbitalControlsView(viewModel: viewModel)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)

                        TitledCard(
                            title: "Graphs",
                            description: "Switch between kinetic, potential, total energy, and orbital radius, or view the energy overview."
                        ) {
                            VStack(spacing: 12) {
                                Picker("Graph", selection: $selectedGraphTab) {
                                    Text("KE").tag("KE")
                                    Text("PE").tag("PE")
                                    Text("Total E").tag("Total E")
                                    Text("Radius").tag("Radius")
                                    Text("All").tag("All")
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: selectedGraphTab) { newValue in
                                    switch newValue {
                                    case "KE": viewModel.selectedGraph = .kineticEnergy
                                    case "PE": viewModel.selectedGraph = .potentialEnergy
                                    case "Total E": viewModel.selectedGraph = .totalEnergy
                                    case "Radius": viewModel.selectedGraph = .radius
                                    default: break
                                    }
                                }
                                
                                if selectedGraphTab == "All" {
                                    OrbitalAllEnergyGraph(viewModel: viewModel)
                                        .frame(height: 220)
                                } else {
                                    OrbitalGraphView(viewModel: viewModel)
                                        .frame(height: 220)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: isRegular ? 460 : 390)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            TitledCard(
                                title: "Adjust Parameters",
                                description: "Adjust launch speed, angle, altitude, and planet mass to see how the orbit changes."
                            ) {
                                OrbitalControlsView(viewModel: viewModel)
                            }
                            .frame(width: 310, height: isRegular ? 460 : 390)

                            TitledCard(
                                title: "Graphs",
                                description: "Switch between kinetic, potential, total energy, and orbital radius, or view the energy overview."
                            ) {
                                VStack(spacing: 12) {
                                    Picker("Graph", selection: $selectedGraphTab) {
                                        Text("KE").tag("KE")
                                        Text("PE").tag("PE")
                                        Text("Total E").tag("Total E")
                                        Text("Radius").tag("Radius")
                                        Text("All").tag("All")
                                    }
                                    .pickerStyle(.segmented)
                                    .onChange(of: selectedGraphTab) { newValue in
                                        switch newValue {
                                        case "KE": viewModel.selectedGraph = .kineticEnergy
                                        case "PE": viewModel.selectedGraph = .potentialEnergy
                                        case "Total E": viewModel.selectedGraph = .totalEnergy
                                        case "Radius": viewModel.selectedGraph = .radius
                                        default: break
                                        }
                                    }
                                    
                                    if selectedGraphTab == "All" {
                                        OrbitalAllEnergyGraph(viewModel: viewModel)
                                            .frame(height: 220)
                                    } else {
                                        OrbitalGraphView(viewModel: viewModel)
                                            .frame(height: 220)
                                    }
                                }
                            }
                            .frame(width: 310, height: isRegular ? 460 : 390)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16) // Allows scrolling edge-to-edge
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .onAppear {
            switch viewModel.selectedGraph {
            case .kineticEnergy: selectedGraphTab = "KE"
            case .potentialEnergy: selectedGraphTab = "PE"
            case .totalEnergy: selectedGraphTab = "Total E"
            case .radius: selectedGraphTab = "Radius"
            }
        }
    }
}

struct OrbitalSimulationPanel: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        VStack(spacing: 12) {
            OrbitalCanvas(viewModel: viewModel)
                .frame(height: 320)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#080D18")))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.primaryAccent.opacity(0.2), lineWidth: 1))
                .padding(.horizontal)

            OrbitalStatusBar(viewModel: viewModel)
                .padding(.horizontal)

            OrbitalPlaybackControls(viewModel: viewModel)
                .padding(.horizontal)
            
            Divider()
                .background(AppTheme.tertiaryText.opacity(0.3))
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Display Options")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.primaryText)
                
                OrbitalToggles(viewModel: viewModel)
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
        }
    }
}

struct OrbitalControlsView: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                OrbitalSliderPanel(viewModel: viewModel)
                
                Divider()
                    .background(AppTheme.tertiaryText.opacity(0.3))
                
                OrbitalPresetRow(viewModel: viewModel)
            }
            .padding(.vertical, 4)
        }
    }
}

struct OrbitalCanvas: View {
    var viewModel: OrbitalMechanicsViewModel


    private let scale: Double = 1.5

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            ZStack {

                ForEach(0..<30, id: \.self) { i in
                    let x = Double(i * 137 % Int(geo.size.width))
                    let y = Double(i * 97  % Int(geo.size.height))
                    Circle()
                        .fill(Color.white.opacity(Double(i % 4) * 0.15 + 0.1))
                        .frame(width: 1.5, height: 1.5)
                        .position(x: x, y: y)
                }


                if viewModel.showTrail && viewModel.trail.count > 1 {
                    OrbitalTrailShape(trail: viewModel.trail, center: center, scale: scale)
                        .stroke(AppTheme.primaryAccent.opacity(0.4),
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                }


                let pRadius = CGFloat(viewModel.simPlanetRadius / scale)
                Circle()
                    .fill(RadialGradient(
                        colors: [viewModel.preset.color, viewModel.preset.color.opacity(0.5)],
                        center: .topLeading, startRadius: 0, endRadius: pRadius))
                    .frame(width: pRadius * 2, height: pRadius * 2)
                    .position(center)
                    .shadow(color: viewModel.preset.color.opacity(0.4), radius: 8)


                let satPos = simToCanvas(viewModel.simPosition, center: center)

                if viewModel.showGravityVector {
                    let dir = viewModel.simPosition.normalized
                    OrbitalVectorArrow(from: satPos,
                                       dir: Vector2D(x: -dir.x, y: dir.y),
                                       length: 40, color: .red)
                }
                if viewModel.showAccelerationVector {
                    let am = viewModel.simAcceleration.magnitude
                    if am > 0 {
                        let a = viewModel.simAcceleration
                        OrbitalVectorArrow(from: satPos,
                                           dir: Vector2D(x: a.x / am, y: -a.y / am),
                                           length: 35, color: .orange)
                    }
                }
                if viewModel.showVelocityVector {
                    let vm = viewModel.simVelocity.magnitude
                    if vm > 0 {
                        let v = viewModel.simVelocity
                        OrbitalVectorArrow(from: satPos,
                                           dir: Vector2D(x: v.x / vm, y: -v.y / vm),
                                           length: min(50, CGFloat(vm * 8)), color: .green)
                    }
                }


                if !viewModel.hasCrashed {
                    Circle().fill(.white)
                        .frame(width: 8, height: 8)
                        .shadow(color: .white.opacity(0.6), radius: 4)
                        .position(satPos)
                        .accessibilityElement()
                        .accessibilityLabel(viewModel.simulationBodyAccessibilityLabel)
                        .accessibilityAddTraits(.updatesFrequently)
                }


                if viewModel.hasCrashed || viewModel.hasEscaped {
                    VStack(spacing: 4) {
                        Image(systemName: viewModel.hasCrashed
                              ? "exclamationmark.triangle.fill"
                              : "arrow.up.forward.circle.fill")
                            .font(.title)
                            .foregroundStyle(viewModel.hasCrashed ? .red : .orange)
                        Text(viewModel.statusMessage)
                            .font(.caption).fontWeight(.semibold).foregroundStyle(.white)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.black.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .position(x: geo.size.width / 2, y: 30)
                }


                VStack(alignment: .leading, spacing: 4) {
                    if viewModel.showVelocityVector     { OrbitalLegendDot(color: .green,  label: "v") }
                    if viewModel.showAccelerationVector { OrbitalLegendDot(color: .orange, label: "a") }
                    if viewModel.showGravityVector      { OrbitalLegendDot(color: .red,    label: "g") }
                }
                .padding(8)
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .position(x: 36, y: 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func simToCanvas(_ v: Vector2D, center: CGPoint) -> CGPoint {
        CGPoint(x: center.x + CGFloat(v.x / scale),
                y: center.y - CGFloat(v.y / scale))
    }
}

struct OrbitalTrailShape: Shape {
    let trail: [Vector2D]
    let center: CGPoint
    let scale: Double

    func path(in rect: CGRect) -> Path {
        var p = Path()
        guard trail.count > 1 else { return p }
        p.move(to: toCanvas(trail[0]))
        for v in trail.dropFirst() { p.addLine(to: toCanvas(v)) }
        return p
    }
    private func toCanvas(_ v: Vector2D) -> CGPoint {
        CGPoint(x: center.x + CGFloat(v.x / scale),
                y: center.y - CGFloat(v.y / scale))
    }
}

struct OrbitalVectorArrow: View {
    let from: CGPoint
    let dir: Vector2D
    let length: CGFloat
    let color: Color

    var body: some View {
        let to = CGPoint(x: from.x + CGFloat(dir.x) * length,
                         y: from.y + CGFloat(dir.y) * length)
        return OrbitalArrowShape(from: from, to: to)
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
}

struct OrbitalArrowShape: Shape {
    let from: CGPoint
    let to:   CGPoint

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from); p.addLine(to: to)
        let dx = to.x - from.x, dy = to.y - from.y
        let len = sqrt(dx*dx + dy*dy)
        guard len > 4 else { return p }
        let ux = dx/len, uy = dy/len
        let al: CGFloat = 8, aw: CGFloat = 4
        p.move(to: to)
        p.addLine(to: CGPoint(x: to.x - al*ux - aw*uy, y: to.y - al*uy + aw*ux))
        p.move(to: to)
        p.addLine(to: CGPoint(x: to.x - al*ux + aw*uy, y: to.y - al*uy - aw*ux))
        return p
    }
}

struct OrbitalLegendDot: View {
    let color: Color; let label: String
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label).font(.system(size: 9, weight: .medium)).foregroundStyle(.white)
        }
    }
}

struct OrbitalStatusBar: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        HStack(spacing: 0) {
            OrbitalStatCell(label: "Orbit Type",
                            value: viewModel.orbitType.rawValue,
                            color: viewModel.orbitType.color)
            Divider().frame(height: 40).background(AppTheme.tertiaryText)
            OrbitalStatCell(label: "Speed",
                            value: viewModel.speedDisplay,
                            color: .green)
            Divider().frame(height: 40).background(AppTheme.tertiaryText)
            OrbitalStatCell(label: "Altitude",
                            value: viewModel.altitudeDisplay,
                            color: .purple)
            Divider().frame(height: 40).background(AppTheme.tertiaryText)
            OrbitalStatCell(label: "Total E",
                            value: String(format: "%.1f km²/s²", viewModel.totalEnergyReal),
                            color: .cyan)
        }
        .padding(8)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.primaryAccent.opacity(0.1), lineWidth: 1))
    }
}

struct OrbitalStatCell: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 2) {
            Text(label).font(.system(size: 9)).foregroundStyle(AppTheme.secondaryText)
            Text(value)
                .font(.system(size: 11, weight: .semibold)).foregroundStyle(color)
                .minimumScaleFactor(0.5).lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct OrbitalPlaybackControls: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        HStack(spacing: 24) {
            Button(action: {
                Haptics.playPause()
                viewModel.toggleRunning()
            }) {
                Image(systemName: viewModel.isRunning ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.blue)
            }
            .disabled(viewModel.hasCrashed || viewModel.hasEscaped)

            Button(action: {
                Haptics.reset()
                viewModel.resetSimulation()
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.orange)
            }

            Spacer()
        }
    }
}

struct OrbitalToggles: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                OrbitalToggleChip(label: "Velocity (v)",     color: .green,  isOn: Binding(get: { viewModel.showVelocityVector }, set: { viewModel.showVelocityVector = $0 }))
                OrbitalToggleChip(label: "Acceleration (a)", color: .orange, isOn: Binding(get: { viewModel.showAccelerationVector }, set: { viewModel.showAccelerationVector = $0 }))
                OrbitalToggleChip(label: "Gravity (g)",      color: .red,    isOn: Binding(get: { viewModel.showGravityVector }, set: { viewModel.showGravityVector = $0 }))
                OrbitalToggleChip(label: "Orbit Trail",      color: AppTheme.primaryAccent, isOn: Binding(get: { viewModel.showTrail }, set: { viewModel.showTrail = $0 }))
            }

            HStack {
                Text("Integrator:")
                    .font(.caption).foregroundStyle(AppTheme.secondaryText)
                Picker("Integrator", selection: Binding(get: { viewModel.integrator }, set: { viewModel.integrator = $0 })) {
                    ForEach(IntegratorType.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct OrbitalToggleChip: View {
    let label: String; let color: Color; @Binding var isOn: Bool
    var body: some View {
        Button(action: {
            Haptics.toggleChanged()
            isOn.toggle()
        }) {
            HStack(spacing: 6) {
                Circle().fill(isOn ? color : Color.gray.opacity(0.4)).frame(width: 8, height: 8)
                Text(label).font(.caption).foregroundStyle(isOn ? AppTheme.primaryText : AppTheme.secondaryText)
                Spacer()
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(isOn ? color.opacity(0.1) : AppTheme.surfaceBackground))
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(isOn ? color.opacity(0.3) : Color.clear, lineWidth: 1))
        }
    }
}

struct OrbitalSliderPanel: View {
    var viewModel: OrbitalMechanicsViewModel
    @State private var speedBefore:  Double = 0
    @State private var angleBefore:  Double = 0
    @State private var radiusBefore: Double = 0
    @State private var massBefore:   Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Spacer()
                Text("Units: real km/s & km")
                    .font(.system(size: 9)).foregroundStyle(AppTheme.tertiaryText)
            }



            let minSpeedSim = 0.5, maxSpeedSim = 8.0
            OrbitalSliderRow(
                label: "Launch Speed",
                valueDisplay: viewModel.launchSpeedDisplay,
                sliderValue: Binding(
                    get: { viewModel.simLaunchSpeed },
                    set: { viewModel.simLaunchSpeed = $0 }
                ),
                range: minSpeedSim...maxSpeedSim,
                color: .green,
                hint: "Circular: \(viewModel.circularDisplay)  •  Escape: \(viewModel.escapeDisplay)",
                onEditStart: { speedBefore = viewModel.simLaunchSpeed },
                onEditEnd: {
                    viewModel.trackSpeed(fromSimSpeed: speedBefore)
                    viewModel.resetSimulation()
                }
            )


            OrbitalSliderRow(
                label: "Launch Angle",
                valueDisplay: String(format: "%.0f°", viewModel.launchAngleDeg),
                sliderValue: Binding(get: { viewModel.launchAngleDeg }, set: { viewModel.launchAngleDeg = $0 }),
                range: 0...360,
                color: .yellow,
                hint: "90° = tangential (best for circular orbit)",
                onEditStart: { angleBefore = viewModel.launchAngleDeg },
                onEditEnd: {
                    viewModel.trackAngle(from: angleBefore)
                    viewModel.resetSimulation()
                }
            )


            let minSimR = viewModel.simPlanetRadius + 5
            let maxSimR = 350.0
            let altDisplay: String = {
                let alt = max(0, (viewModel.simOrbitRadius - viewModel.simPlanetRadius) * viewModel.kmPerSimUnit)
                return String(format: "%.0f km altitude", alt)
            }()
            OrbitalSliderRow(
                label: "Orbit Altitude",
                valueDisplay: altDisplay,
                sliderValue: Binding(
                    get: { viewModel.simOrbitRadius },
                    set: { viewModel.simOrbitRadius = $0 }
                ),
                range: minSimR...maxSimR,
                color: .purple,
                hint: "Radius from centre: \(viewModel.radiusDisplay)",
                onEditStart: { radiusBefore = viewModel.simOrbitRadius },
                onEditEnd: {
                    viewModel.trackAltitude(fromSimRadius: radiusBefore)
                    viewModel.resetSimulation()
                }
            )



            let earthEquiv = viewModel.simPlanetMass / 1200.0
            let massDisplay: String = {
                if earthEquiv < 0.15 { return String(format: "%.2f M⊕  (≈Moon-like)", earthEquiv) }
                if abs(earthEquiv - 1.0) < 0.05 { return String(format: "%.2f M⊕  (≈Earth)", earthEquiv) }
                if abs(earthEquiv - 0.67) < 0.05 { return String(format: "%.2f M⊕  (≈Mars-like)", earthEquiv) }
                return String(format: "%.2f M⊕", earthEquiv)
            }()
            OrbitalSliderRow(
                label: "Planet Mass",
                valueDisplay: massDisplay,
                sliderValue: Binding(get: { viewModel.simPlanetMass }, set: { viewModel.simPlanetMass = $0 }),
                range: 100...3000,
                color: .orange,
                hint: "1.00 M⊕ = Earth  •  0.17 M⊕ = Moon  •  0.67 M⊕ = Mars",
                onEditStart: { massBefore = viewModel.simPlanetMass },
                onEditEnd: {
                    viewModel.trackMass(fromSimMass: massBefore)
                    viewModel.preset = .custom
                    viewModel.resetSimulation()
                }
            )
        }
    }
}

struct OrbitalSliderRow: View {
    let label: String
    let valueDisplay: String
    @Binding var sliderValue: Double
    let range: ClosedRange<Double>
    let color: Color
    let hint: String?
    var onEditStart: (() -> Void)? = nil
    var onEditEnd:   (() -> Void)? = nil
    @State private var isDragging = false

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label).font(.caption).foregroundStyle(AppTheme.secondaryText)
                Spacer()
                Text(valueDisplay).font(.caption).fontWeight(.semibold).foregroundStyle(color)
            }
            Slider(value: $sliderValue, in: range)
                .tint(color)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isDragging {
                                isDragging = true
                                Haptics.sliderStart()
                                onEditStart?()
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            Haptics.sliderEnd()
                            onEditEnd?()
                        }
                )
            if let hint = hint {
                Text(hint).font(.system(size: 9)).foregroundStyle(AppTheme.tertiaryText)
            }
        }
    }
}

struct OrbitalPresetRow: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presets")
                .font(.caption).foregroundStyle(AppTheme.secondaryText)

            HStack(spacing: 8) {
                ForEach(OrbitalPreset.allCases, id: \.self) { p in
                    Button(action: {
                        Haptics.presetSelected()
                        viewModel.preset = p
                    }) {
                        VStack(spacing: 3) {
                            Image(systemName: p.icon)
                                .font(.title3)
                                .foregroundStyle(viewModel.preset == p ? .white : p.color)
                            Text(p.rawValue)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(viewModel.preset == p ? .white : AppTheme.secondaryText)
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.preset == p ? p.color : p.color.opacity(0.1)))
                    }
                }
            }


            if viewModel.preset != .custom {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.preset.description)
                        .font(.system(size: 10)).foregroundStyle(AppTheme.tertiaryText)
                    HStack(spacing: 12) {
                        OrbitalRealFact(label: "Circular", value: viewModel.circularDisplay, color: .cyan)
                        OrbitalRealFact(label: "Escape",   value: viewModel.escapeDisplay,   color: .orange)
                        OrbitalRealFact(label: "Surface v_esc", value: viewModel.surfaceEscapeDisplay, color: .red)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}

struct OrbitalRealFact: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(label).font(.system(size: 8)).foregroundStyle(AppTheme.tertiaryText)
            Text(value).font(.system(size: 11, weight: .bold)).foregroundStyle(color)
        }
    }
}



struct OrbitalGraphView: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        let gt     = viewModel.selectedGraph
        let values = gt.values(from: viewModel.energyHistory)
        let mn     = values.min() ?? 0
        let mx     = values.max() ?? 1
        let range  = max(mx - mn, 0.01)

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(gt.label) vs Time  (\(gt.unit))")
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                Spacer()
                Circle().fill(gt.color).frame(width: 8, height: 8)
            }
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<4, id: \.self) { i in
                        let y = geo.size.height * CGFloat(i) / 3
                        Path { p in p.move(to: .init(x: 0, y: y)); p.addLine(to: .init(x: geo.size.width, y: y)) }
                            .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                    }
                    Path { p in
                        p.move(to: .init(x: 0, y: 0))
                        p.addLine(to: .init(x: 0, y: geo.size.height))
                        p.addLine(to: .init(x: geo.size.width, y: geo.size.height))
                    }.stroke(Color.white.opacity(0.2), lineWidth: 1)

                    if mn < 0 && mx > 0 {
                        let zy = geo.size.height * CGFloat(-mn / range)
                        Path { p in p.move(to: .init(x: 0, y: zy)); p.addLine(to: .init(x: geo.size.width, y: zy)) }
                            .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [4,4]))
                    }

                    if values.count > 1 {
                        Path { p in
                            for (i, v) in values.enumerated() {
                                let x = CGFloat(i) / CGFloat(values.count - 1) * geo.size.width
                                let y = geo.size.height * (1 - CGFloat((v - mn) / range))
                                if i == 0 { p.move(to: .init(x: x, y: y)) }
                                else       { p.addLine(to: .init(x: x, y: y)) }
                            }
                        }.stroke(gt.color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    } else {
                        Text("Run simulation to see graph")
                            .font(.caption).foregroundStyle(AppTheme.tertiaryText)
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                    }
                }
            }
        }
        .padding(12)
        .background(AppTheme.cardBackground).clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.primaryAccent.opacity(0.1), lineWidth: 1))
    }
}

struct OrbitalAllEnergyGraph: View {
    var viewModel: OrbitalMechanicsViewModel

    var body: some View {
        let h = viewModel.energyHistory
        let all = h.flatMap { [$0.ke, $0.pe, $0.total] }
        let mn = all.min() ?? -10
        let mx = all.max() ?? 10
        let rng = max(mx - mn, 0.01)

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Energy Overview  (km²/s²)")
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(AppTheme.primaryText)
                Spacer()
                HStack(spacing: 8) {
                    OrbitalLegendDot(color: .orange, label: "KE")
                    OrbitalLegendDot(color: .blue,   label: "PE")
                    OrbitalLegendDot(color: .cyan,   label: "Total")
                }
            }
            GeometryReader { geo in
                ZStack {
                    Path { p in
                        p.move(to: .init(x: 0, y: 0))
                        p.addLine(to: .init(x: 0, y: geo.size.height))
                        p.addLine(to: .init(x: geo.size.width, y: geo.size.height))
                    }.stroke(Color.white.opacity(0.2), lineWidth: 1)

                    if h.count > 1 {
                        energyLine(h.map { $0.ke },    color: .orange, geo: geo, mn: mn, rng: rng)
                        energyLine(h.map { $0.pe },    color: .blue,   geo: geo, mn: mn, rng: rng)
                        energyLine(h.map { $0.total }, color: .cyan,   geo: geo, mn: mn, rng: rng)
                    }
                }
            }
        }
        .padding(12)
        .background(AppTheme.cardBackground).clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.primaryAccent.opacity(0.1), lineWidth: 1))
    }

    func energyLine(_ vals: [Double], color: Color, geo: GeometryProxy, mn: Double, rng: Double) -> some View {
        Path { p in
            for (i, v) in vals.enumerated() {
                let x = CGFloat(i) / CGFloat(vals.count - 1) * geo.size.width
                let y = geo.size.height * (1 - CGFloat((v - mn) / rng))
                if i == 0 { p.move(to: .init(x: x, y: y)) }
                else       { p.addLine(to: .init(x: x, y: y)) }
            }
        }.stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
    }
}


