//
//  IntroductionSheet.swift
//  Kinetica
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

struct IntroductionSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to Kinetica!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.primaryText)

                        Text("This app helps you master physics concepts through interactive visualization and hands-on exploration.")
                            .font(.body)
                            .foregroundStyle(AppTheme.secondaryText)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 16) {
                        Text("How to Use")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.primaryText)

                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            color: AppTheme.blueCard,
                            title: "Visualize Tab",
                            description: "Watch real-time simulations. Adjust parameters and see graphs update instantly. Use Focus mode for single graphs or Compare mode to see relationships."
                        )

                        FeatureRow(
                            icon: "book.fill",
                            color: AppTheme.greenCard,
                            title: "Learn Tab",
                            description: "Deep dive into concepts. Read explanations, explore misconceptions, test your understanding with interactive questions, and track your changes."
                        )

                        FeatureRow(
                            icon: "slider.horizontal.3",
                            color: AppTheme.orangeCard,
                            title: "Interactive Controls",
                            description: "Adjust sliders to change motion parameters. Watch how changing one value affects the entire system in real-time."
                        )
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Learning Tips")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.primaryText)

                        VStack(alignment: .leading, spacing: 10) {
                            TipRow(tip: "Start with Linear Motion to build fundamentals")
                            TipRow(tip: "Switch between Visualize and Learn tabs to connect concepts")
                            TipRow(tip: "Pause simulations to examine specific moments")
                            TipRow(tip: "Try extreme values to see boundary behaviors")
                            TipRow(tip: "Answer the interactive questions to test understanding")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Getting Started")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.primaryAccent)
                }
            }
        }
    }
}


#Preview {
    IntroductionSheet()
}
