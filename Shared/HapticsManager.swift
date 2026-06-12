

import SwiftUI
import UIKit

enum Haptics {



    static func playPause() { impact(.medium) }


    static func reset() { impact(.rigid) }



    static func bounce() { impact(.heavy) }


    static func landing() { impact(.heavy) }


    static func crash() { notification(.error) }


    static func escape() { notification(.success) }


    static func thresholdCrossed() { notification(.warning) }



    static func sliderStart() { selection() }


    static func sliderEnd() { impact(.soft) }


    static func presetSelected() { impact(.light) }



    static func toggleChanged() { selection() }



    static func cardTapped() { impact(.light) }



    static func correctAnswer() { notification(.success) }


    static func wrongAnswer() { notification(.error) }


    private static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred()
    }

    private static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(type)
    }

    private static func selection() {
        let gen = UISelectionFeedbackGenerator()
        gen.prepare()
        gen.selectionChanged()
    }
}

extension View {

    func hapticOnChange<V: Equatable>(of value: V,
                                      perform feedback: @escaping (V) -> Void) -> some View {
        self.onChange(of: value) { _, newVal in feedback(newVal) }
    }
}
