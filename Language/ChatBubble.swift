

import SwiftUI

struct ChatBubbleView: View {
    let message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == .assistant {
                Text("🐒")
                    .font(.system(size: 16))
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(Color.blue))

                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground))
                    .foregroundStyle(Color(.label))
                    .clipShape(BubbleShape(isFromUser: false))
                Spacer(minLength: 48)
            } else {
                Spacer(minLength: 48)
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(BubbleShape(isFromUser: true))
            }
        }
    }
}

private struct BubbleShape: Shape {
    let isFromUser: Bool
    func path(in rect: CGRect) -> Path {
        let r: CGFloat = 18
        let smallR: CGFloat = 4
        var path = Path()
        if isFromUser {
            path.addRoundedRect(in: rect, cornerRadii: .init(topLeading: r, bottomLeading: r, bottomTrailing: smallR, topTrailing: r))
        } else {
            path.addRoundedRect(in: rect, cornerRadii: .init(topLeading: r, bottomLeading: smallR, bottomTrailing: r, topTrailing: r))
        }
        return path
    }
}
