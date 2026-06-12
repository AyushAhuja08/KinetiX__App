
import SwiftUI

struct KeyMomentMarker: View {
    let label: String
    let sublabel: String?
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 24, height: 24)

                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)

                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: 24, height: 24)
            }

            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(color)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(Color(.systemBackground).opacity(0.95))
                )

            if let sublabel = sublabel {
                Text(sublabel)
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
