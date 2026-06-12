
import SwiftUI

struct BulletPoint: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.subheadline)
                .foregroundStyle(color)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryText.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
