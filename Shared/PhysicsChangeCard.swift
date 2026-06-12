
import SwiftUI

struct PhysicsChangeCard: View {
    let parameter: String
    let headline: String
    let explanation: String
    let icon: String
    let color: Color
    let timestamp: String

    @State private var expanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            }) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundStyle(color)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(parameter)
                            .font(.caption2).fontWeight(.semibold)
                            .foregroundStyle(color)
                        Text(headline)
                            .font(.caption)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                    }
                    Spacer()
                    Text(timestamp)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(10)
            }

            if expanded {
                Divider()
                    .background(color.opacity(0.2))
                VStack(alignment: .leading, spacing: 0) {
                    Text(explanation)
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(color.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}
