
import SwiftUI

struct ChangeImpactView: View {
    let changeType: String
    let icon: String
    let beforeValue: String
    let afterValue: String
    let impact: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)

                Text("Parameter Change: \(changeType)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Before")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(beforeValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundStyle(color)

                VStack(alignment: .leading, spacing: 4) {
                    Text("After")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(afterValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(color)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
                Text(impact)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1.5)
        )
    }
}
