
import SwiftUI

struct EducationalSlider: View {
    let label: String
    let value: Binding<Double>
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let color: Color
    let icon: String
    let explanation: (Double) -> String

    @State private var showingExplanation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(color)

                    Text(label)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(String(format: "%.1f", value.wrappedValue))
                        .font(.subheadline)
                        .foregroundStyle(color)
                        .fontWeight(.semibold)
                    Text(unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button(action: { withAnimation(.spring(response: 0.3)) { showingExplanation.toggle() } }) {
                    Image(systemName: showingExplanation ? "questionmark.circle.fill" : "questionmark.circle")
                        .font(.subheadline)
                        .foregroundStyle(color)
                }
            }

            Slider(value: value, in: range, step: step)
                .tint(color)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in }
                        .onEnded { _ in Haptics.sliderEnd() }
                )

            if showingExplanation {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundStyle(color.opacity(0.7))
                    Text(explanation(value.wrappedValue))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(8)
                .background(color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
