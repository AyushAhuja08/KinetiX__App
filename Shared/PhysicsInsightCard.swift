
import SwiftUI

struct PhysicsInsightCard: View {
    let title: String
    let icon: String
    let color: Color
    let explanation: String
    let formula: String?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        VStack(alignment: .leading, spacing: isRegular ? 14 : 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(isRegular ? .title2 : .title3)
                    .foregroundStyle(color)
                    .frame(width: isRegular ? 34 : 28, height: isRegular ? 34 : 28)

                Text(title)
                    .font(isRegular ? .body : .subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }

            Text(explanation)
                .font(isRegular ? .subheadline : .caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(isRegular ? 4 : 2)

            Spacer(minLength: 0)

            if let formula = formula {
                Text(formula)
                    .font(.system(isRegular ? .subheadline : .caption, design: .monospaced))
                    .foregroundStyle(color.opacity(0.8))
                    .padding(.horizontal, isRegular ? 12 : 8)
                    .padding(.vertical, isRegular ? 6 : 4)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(isRegular ? 16 : 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: color.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Physics insight: \(title). \(explanation)\(formula != nil ? " Formula: \(formula!)" : "")")
    }
}
