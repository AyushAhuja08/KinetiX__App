import SwiftUI
import FoundationModels

struct ChatContainerView: View {
    private let model = SystemLanguageModel.default
    var body: some View {
        switch model.availability{
        case .available:
            ChatView()
        case .unavailable(.appleIntelligenceNotEnabled):
            Text("Enable Apple Intelligence in Settings.")
        case .unavailable(.modelNotReady):
                    Text("Model not ready. Try again later.")
        default:
                   Text("Device not eligible for Apple Intelligence.")

        }
    }
}
