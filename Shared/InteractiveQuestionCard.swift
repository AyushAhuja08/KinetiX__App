
import SwiftUI

@MainActor struct InteractiveQuestionCard: View {
    let title: String
    let icon: String
    let color: Color
    let questions: [QA]
    @State private var revealedAnswers: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .imageScale(.medium)
                    .foregroundStyle(color)
                Text(title)
                    .fontWeight(.bold)
            }
            .font(.title3)
            .foregroundStyle(color)

            VStack(spacing: 12) {
                ForEach(questions.indices, id: \.self) { index in
                    QuestionRow(
                        index: index,
                        question: questions[index].question,
                        answer: questions[index].answer,
                        color: color,
                        isRevealed: revealedAnswers.contains(index),
                        onReveal: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                _ = revealedAnswers.insert(index)
                            }
                            Haptics.correctAnswer()
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        )
    }
}

@MainActor private struct QuestionRow: View {
    let index: Int
    let question: String
    let answer: String
    let color: Color
    let isRevealed: Bool
    let onReveal: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 10) {
                Text("\(index + 1).")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                Text(question)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if isRevealed {
                answerView
            } else {
                revealButton
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var answerView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
            Text(answer)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    private var revealButton: some View {
        Button(action: onReveal) {
            HStack {
                Image(systemName: "eye")
                    .font(.caption)
                Text("Reveal Answer")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
