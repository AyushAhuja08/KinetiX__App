
import SwiftUI

struct LiveValuesPanel: View {
    let values: [LiveValue]
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    struct LiveValue: Identifiable {
        let id = UUID()
        let label: String
        let value: String
        let icon: String
        let color: Color
        let unit: String
    }

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        VStack(spacing: isRegular ? 16 : 10) {
            ForEach(values) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .font(isRegular ? .title2 : .title3)
                        .foregroundStyle(item.color)
                        .frame(width: isRegular ? 38 : 30)

                    Text(item.label)
                        .font(isRegular ? .body : .subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    HStack(spacing: 3) {
                        Text(item.value)
                            .font(isRegular ? .title3 : .headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(item.color)
                        Text(item.unit)
                            .font(isRegular ? .subheadline : .caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, isRegular ? 16 : 12)
                .padding(.vertical, isRegular ? 12 : 8)
                .background(item.color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(item.label): \(item.value) \(item.unit)")
                .accessibilityAddTraits(.updatesFrequently)
            }
        }
    }
}
