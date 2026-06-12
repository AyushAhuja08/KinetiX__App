import SwiftUI

struct ChatView: View {
    @State private var chat = ChatSession()
    @State private var input = ""
    @State private var isSending = false
    @FocusState private var isInputFocused: Bool

    private var canSend: Bool {
        !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if chat.messages.isEmpty && !isSending {
                            VStack(spacing: 12) {
                                Text("🐒")
                                    .font(.system(size: 56))
                                Text("Professor Banana")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.primaryText)
                                Text("Ask me anything about kinematics, projectile motion, or orbital mechanics!")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        }

                        ForEach(chat.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }

                        if isSending {
                            HStack(alignment: .bottom, spacing: 8) {
                                Text("🐒")
                                    .font(.system(size: 16))
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(Color.blue))

                                TypingIndicatorView()

                                Spacer(minLength: 48)
                            }
                            .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .onChange(of: chat.messages.count) { _, _ in
                    if let last = chat.messages.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isSending) { _, sending in
                    if sending {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack(spacing: 12) {
                TextField("Ask about physics...", text: $input, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .focused($isInputFocused)
                    .disabled(isSending)

                Button {
                    Task {
                        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !text.isEmpty else { return }
                        input = ""
                        isSending = true
                        await chat.send(text)
                        isSending = false
                    }
                } label: {
                    if isSending {
                        ProgressView()
                            .frame(width: 32, height: 32)
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(canSend ? Color.blue : Color.gray)
                    }
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .navigationTitle("Physics Assistant")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TypingIndicatorView: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.secondary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(i) * 0.15),
                        value: animating
                    )
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .onAppear { animating = true }
    }
}
