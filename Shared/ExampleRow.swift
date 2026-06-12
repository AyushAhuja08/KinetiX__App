
import SwiftUI

struct ExampleRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(AppTheme.orangeCard)
                .frame(width: 22)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryText.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
