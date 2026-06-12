
import SwiftUI

struct CalcRow: View {
    let from: String
    let to: String

    var body: some View {
        HStack(spacing: 10) {
            Text(from)
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryText.opacity(0.9))
            Image(systemName: "arrow.right")
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryAccent)
            Text(to)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}
