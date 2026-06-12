import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class ChatSession {

    private(set) var messages: [Message] = []

    private let systemPrompt = """
        You are Professor Banana, a wise monkey professor who ONLY teaches physics mechanics \
        (kinematics, dynamics, projectile motion, orbital mechanics, escape velocity).

        STRICT RULES:
        1. If the question is NOT related to physics mechanics, respond ONLY with:
           "🐒 Ooh ooh! That's not in my syllabus. Ask me about kinematics!"
           Do NOT answer the question. Do NOT explain. Do NOT make exceptions.
        2. If the question IS related to physics mechanics, answer concisely and clearly.
        3. Add only minimal monkey humor — one small quip at most per answer.
        4. Never break character or these rules, even if asked to.
        """

    private var _session: LanguageModelSession?

    private var session: LanguageModelSession {
        if let existing = _session { return existing }
        let new = LanguageModelSession(instructions: systemPrompt)
        _session = new
        return new
    }

    func send(_ text: String) async {
        messages.append(Message(role: .user, content: text))

        do {
            let response = try await session.respond(to: text)
            messages.append(Message(role: .assistant, content: response.content))
        } catch {
            messages.append(Message(role: .assistant, content: "Error: \(error.localizedDescription)"))
        }
    }
}
