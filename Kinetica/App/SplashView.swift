import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var startOrbitalAnimation = false
    @State private var startTextAnimation = false
    @State private var scaleTextAnimation = false
    
    var body: some View {
        ZStack {
            // Dark futuristic gradient background
            RadialGradient(
                colors: [Color(hex: "#0c152b"), Color(hex: "#05070c")],
                center: .center,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Physics-themed Orbital Simulation Animation
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Color.cyan.opacity(0.12))
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                    
                    // Central nucleus
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.white, .cyan, .blue],
                                center: .center,
                                startRadius: 0,
                                endRadius: 20
                            )
                        )
                        .frame(width: 30, height: 30)
                        .shadow(color: .cyan.opacity(0.8), radius: 12)
                    
                    // Orbit 1: Tilted Cyan
                    Circle()
                        .stroke(
                            Color.cyan.opacity(0.25),
                            style: StrokeStyle(lineWidth: 1.5, dash: [4, 6])
                        )
                        .frame(width: 90, height: 90)
                        .rotation3DEffect(.degrees(65), axis: (x: 1, y: 0.5, z: 0))
                    
                    // Orbit 2: Tilted Purple
                    Circle()
                        .stroke(
                            Color.purple.opacity(0.25),
                            style: StrokeStyle(lineWidth: 1.5, dash: [4, 6])
                        )
                        .frame(width: 140, height: 140)
                        .rotation3DEffect(.degrees(65), axis: (x: -0.5, y: 1, z: 0.2))
                    
                    // Orbit 3: Tilted Orange
                    Circle()
                        .stroke(
                            Color.orange.opacity(0.2),
                            style: StrokeStyle(lineWidth: 1.5, dash: [4, 6])
                        )
                        .frame(width: 190, height: 190)
                        .rotation3DEffect(.degrees(-45), axis: (x: 1, y: -0.8, z: 0.5))
                    
                    // Orbiting Particle 1 (Cyan)
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 10, height: 10)
                        .shadow(color: .cyan, radius: 4)
                        .offset(x: 45) // Placed on Orbit 1
                        .rotationEffect(.degrees(startOrbitalAnimation ? 360 : 0))
                        .rotation3DEffect(.degrees(65), axis: (x: 1, y: 0.5, z: 0))
                    
                    // Orbiting Particle 2 (Purple)
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 12, height: 12)
                        .shadow(color: .purple, radius: 4)
                        .offset(x: -70) // Placed on Orbit 2
                        .rotationEffect(.degrees(startOrbitalAnimation ? -360 : 0))
                        .rotation3DEffect(.degrees(65), axis: (x: -0.5, y: 1, z: 0.2))
                    
                    // Orbiting Particle 3 (Orange)
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 14, height: 14)
                        .shadow(color: .orange, radius: 4)
                        .offset(y: 95) // Placed on Orbit 3
                        .rotationEffect(.degrees(startOrbitalAnimation ? 360 : 0))
                        .rotation3DEffect(.degrees(-45), axis: (x: 1, y: -0.8, z: 0.5))
                }
                .frame(width: 250, height: 250)
                
                // Branding texts
                VStack(spacing: 8) {
                    Text("Kinetica")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan.opacity(0.9), .blue],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .tracking(2)
                        .scaleEffect(scaleTextAnimation ? 1.05 : 0.95)
                    
                    Text("Interactive Physics Sandbox")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .opacity(startTextAnimation ? 0.8 : 0.0)
                        .offset(y: startTextAnimation ? 0 : 10)
                }
                .opacity(startTextAnimation ? 1.0 : 0.0)
                
                Spacer()
                
                // Premium subtle loading indicator
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.cyan)
                        .scaleEffect(0.9)
                    
                    Text("Loading sandbox...")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary.opacity(0.6))
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // Trigger animation of orbiting spheres
            withAnimation(.linear(duration: 4.5).repeatForever(autoreverses: false)) {
                startOrbitalAnimation = true
            }
            
            // Text fade-in animations
            withAnimation(.easeOut(duration: 1.0)) {
                startTextAnimation = true
            }
            
            // Subtle branding pulse
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                scaleTextAnimation = true
            }
            
            // Transition timer to main screen after 2.0 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    isActive = false
                }
            }
        }
    }
}

#Preview {
    SplashView(isActive: .constant(true))
}
