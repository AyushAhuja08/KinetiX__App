
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        let isRegular = horizontalSizeClass == .regular
        VStack(alignment: .leading, spacing: isRegular ? 12 : 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(isRegular ? .body : .subheadline)
                        .foregroundStyle(color)

                    Text(label)
                        .font(isRegular ? .body : .subheadline)
                        .fontWeight(.medium)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(String(format: "%.1f", value.wrappedValue))
                        .font(isRegular ? .body : .subheadline)
                        .foregroundStyle(color)
                        .fontWeight(.semibold)
                    Text(unit)
                        .font(isRegular ? .subheadline : .caption)
                        .foregroundStyle(.secondary)
                }

                Button(action: { withAnimation(.spring(response: 0.3)) { showingExplanation.toggle() } }) {
                    Image(systemName: showingExplanation ? "questionmark.circle.fill" : "questionmark.circle")
                        .font(isRegular ? .body : .subheadline)
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
                        .font(isRegular ? .subheadline : .caption)
                        .foregroundStyle(color.opacity(0.7))
                    Text(explanation(value.wrappedValue))
                        .font(isRegular ? .subheadline : .caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(isRegular ? 12 : 8)
                .background(color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, isRegular ? 12 : 8)
        .padding(.horizontal, isRegular ? 16 : 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
