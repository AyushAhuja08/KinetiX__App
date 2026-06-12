
import SwiftUI

@MainActor struct ConceptExplanationCard: View {
    let title: String
    let icon: String
    let color: Color
    let explanation: String
    let expandablePoints: [String]?
    @State private var isExpanded = false

    init(title: String, icon: String, color: Color, explanation: String, expandablePoints: [String]? = nil) {
        self.title = title
        self.icon = icon
        self.color = color
        self.explanation = explanation
        self.expandablePoints = expandablePoints
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text(explanation)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if let points = expandablePoints, !points.isEmpty {
                ExpandablePointsList(points: points, color: color, isExpanded: $isExpanded)
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

private struct ExpandablePointsList: View {
    let points: [String]
    let color: Color
    @Binding var isExpanded: Bool

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                    ConceptBulletPoint(text: point, color: color)
                }
            }
            .padding(.top, 8)
        } label: {
            Text(isExpanded ? "Show Less" : "Learn More")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .tint(color)
    }
}

private struct ConceptBulletPoint: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color.opacity(0.7))
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
