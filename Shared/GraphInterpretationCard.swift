
import SwiftUI

@MainActor struct GraphInterpretationCard: View {
    let title: String
    let icon: String
    let color: Color
    let graphName: String
    let interpretations: [(aspect: String, meaning: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text("How to read the \(graphName) graph:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(Array(interpretations.enumerated()), id: \.offset) { _, item in
                    InterpretationRow(aspect: item.aspect, meaning: item.meaning, color: color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

private struct InterpretationRow: View {
    let aspect: String
    let meaning: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.body)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 4) {
                Text(aspect)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(meaning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
