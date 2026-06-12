import SwiftUI

struct OrbitalMechanicsView: View {
    @State private var viewModel = OrbitalMechanicsViewModel()
    @State private var viewSelector: ViewSelector = .visualize

    var body: some View {

        ZStack {
            VStack(spacing: 0) {
                Picker("View Selector", selection: $viewSelector) {
                    ForEach(ViewSelector.allCases, id: \.self) { selectedView in
                        Text(selectedView.rawValue)
                            .tag(selectedView)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                if viewSelector == .visualize {
                    OrbitalMechanicsVisualizeView(viewModel: viewModel)

                } else {
                    OrbitalMechanicsLearnView(viewModel: viewModel)

                }
            }

            FloatingChatButton()
        }
        .navigationTitle("Orbital Mechanics")
        .navigationBarTitleDisplayMode(.inline)
    }
}
