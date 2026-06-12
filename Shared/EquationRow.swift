
import SwiftUI

struct EquationRow: View {
    let equation: String

    var body: some View {
        Text(equation)
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(.medium)
            .foregroundStyle(AppTheme.primaryText)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
