
import SwiftUI

struct PhysicsChangesSection<Content: View>: View {
    let title: String
    let badge: String?
    let isEmpty: Bool
    let emptyPrompt: String
    let onClear: () -> Void
    @ViewBuilder let content: () -> Content

    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded.toggle() }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.15))
                            .frame(width: 34, height: 34)
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.callout)
                            .foregroundStyle(.yellow)
                    }
                    Text(title)
                        .font(.headline).fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Spacer()
                    if let badge = badge {
                        Text(badge)
                            .font(.caption2).fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Capsule().fill(Color.yellow))
                    }
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(14)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    if isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "hand.point.up.left")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text(emptyPrompt)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 16)
                    } else {
                        VStack(spacing: 10) {
                            content()
                                .padding(.top, 12)

                            Button(action: { withAnimation { onClear() } }) {
                                Label("Clear History", systemImage: "trash")
                                    .font(.caption)
                                    .foregroundStyle(.red.opacity(0.8))
                            }
                            .padding(.top, 4)
                            .padding(.bottom, 12)
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(isExpanded ? 0.3 : 0.1), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}
