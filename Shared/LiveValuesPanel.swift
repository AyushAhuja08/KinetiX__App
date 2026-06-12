
import SwiftUI

struct LiveValuesPanel: View {
    let values: [LiveValue]

    struct LiveValue: Identifiable {
        let id = UUID()
        let label: String
        let value: String
        let icon: String
        let color: Color
        let unit: String
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(values) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .font(.title3)
                        .foregroundStyle(item.color)
                        .frame(width: 30)

                    Text(item.label)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    HStack(spacing: 3) {
                        Text(item.value)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(item.color)
                        Text(item.unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(item.color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(item.label): \(item.value) \(item.unit)")
                .accessibilityAddTraits(.updatesFrequently)
            }
        }
    }
}
