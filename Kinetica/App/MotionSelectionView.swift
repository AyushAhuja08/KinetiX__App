//
//  MotionSelectionView.swift
//  Kinetica
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

struct MotionSelectionView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showingIntro = false

    private var motionGridColumns: [GridItem] {
        if horizontalSizeClass == .regular {
            return [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        }
        return [GridItem(.flexible())]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                VStack(spacing: 12) {
                    Text("Kinetica: Interactive Motion")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)

                    Text("Master physics through interactive visualization and deep conceptual understanding")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Learn by Doing", systemImage: "lightbulb.fill")
                        .font(.headline)
                        .foregroundStyle(AppTheme.primaryAccent)

                    Text("Explore the fundamental laws of motion through real-time simulations. Watch graphs change as you adjust parameters, and discover the deep connections between position, velocity, and acceleration.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: { showingIntro = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill")
                            Text("How to Use This App")
                                .fontWeight(.medium)
                        }
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.primaryAccent)
                    }
                    .padding(.top, 2)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppTheme.cardBackground)
                        .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppTheme.primaryAccent.opacity(0.12), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Explore Motion Types")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.primaryText)
                        .padding(.horizontal, 20)

                    LazyVGrid(columns: motionGridColumns, spacing: 14) {
                        NavigationLink { LinearMotionView() } label: {
                            EnhancedMotionCard(
                                title: "Linear Motion",
                                subtitle: "Distance, Velocity & Acceleration",
                                description: "Learn the fundamentals of 1D motion and master the calculus connections",
                                icon: "arrow.right",
                                color: .blue,
                                difficulty: "Beginner"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded { Haptics.cardTapped() })

                        NavigationLink { ProjectileMotionView() } label: {
                            EnhancedMotionCard(
                                title: "Projectile Motion",
                                subtitle: "2D Trajectory & Vector Decomposition",
                                description: "Discover how horizontal and vertical motions combine independently",
                                icon: "figure.archery",
                                color: .orange,
                                difficulty: "Intermediate"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded { Haptics.cardTapped() })

                        NavigationLink { EscapeVelocityView() } label: {
                            EnhancedMotionCard(
                                title: "Escape Velocity",
                                subtitle: "Orbital Mechanics & Energy",
                                description: "Explore gravitational physics and the energy needed to reach infinity",
                                icon: "circle.dotted.and.circle",
                                color: .purple,
                                difficulty: "Advanced"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded { Haptics.cardTapped() })

                        NavigationLink { OrbitalMechanicsView() } label: {
                            EnhancedMotionCard(
                                title: "Orbital Mechanics",
                                subtitle: "Real Physics Engine – Newton's Gravitation",
                                description: "Simulate true orbits with numerical integration. Watch ellipses, parabolas, and escape trajectories emerge naturally from gravity.",
                                icon: "globe.europe.africa.fill",
                                color: .cyan,
                                difficulty: "Expert"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded { Haptics.cardTapped() })
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 32)
            }
            .padding(.vertical, 16)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingIntro) {
            IntroductionSheet()
        }
    }
}

#Preview {
    MotionSelectionView()
}
