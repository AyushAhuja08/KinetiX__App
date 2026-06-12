
import SwiftUI

struct LegendLineRow: View {
    let title: String
    let subtitle: String
    let color: Color
    var dash: [CGFloat] = []

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Capsule()
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: dash))
                .frame(width: 44, height: 4)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.primaryText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
