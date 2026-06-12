import SwiftUI

struct FloatingChatButton: View {
    @State private var showChat = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showChat = true
                }) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color.blue)
                                .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 4)
                        )
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showChat) {
            NavigationStack {
                ChatContainerView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showChat = false
                            }
                            .fontWeight(.semibold)
                        }
                    }
            }
        }
    }
}
