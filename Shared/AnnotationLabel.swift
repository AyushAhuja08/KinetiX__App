
import SwiftUI

struct AnnotationLabel: View {
    let text: String
    let color: Color
    let icon: String?

    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundStyle(color)
            }
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color(.systemBackground).opacity(0.95))
                .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 1)
        )
        .overlay(
            Capsule()
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
    }
}
