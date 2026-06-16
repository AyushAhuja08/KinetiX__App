//
//  EnhancedMotionCard.swift
//  Kinetica
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

struct EnhancedMotionCard: View {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let color: Color
    let difficulty: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.primaryText)

                    Spacer()

                    Text(difficulty)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(color.opacity(0.2)))
                }

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(AppTheme.tertiaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }

            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundStyle(AppTheme.tertiaryText)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 10, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}


#Preview {
    EnhancedMotionCard(title: "Linear Motion",
                       subtitle: "Kinematics & Dynamics",
                       description: "Explore velocity, acceleration and displacement in 1D.",
                       icon: "arrow.right.circle.fill",
                       color: .blue,
                       difficulty: "Beginner"
                   )
                   .padding()
}
