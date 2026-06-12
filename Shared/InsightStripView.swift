
import SwiftUI

struct InsightStripView: View {
    let insight: String

    var body: some View {
        Text(insight)
            .font(.caption)
            .foregroundStyle(AppTheme.secondaryText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(AppTheme.surfaceBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
