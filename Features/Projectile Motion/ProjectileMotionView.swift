import SwiftUI

struct ProjectileMotionView: View {
    @State private var viewModel = ProjectileMotionViewModel()
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
                    ProjectileMotionVisualizeView(viewModel: viewModel)

                } else {
                    ProjectileMotionLearnView(viewModel: viewModel)

                }
            }

            FloatingChatButton()
        }
        .navigationTitle("Projectile Motion")
        .navigationBarTitleDisplayMode(.inline)
    }
}
