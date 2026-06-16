//
//  FeatureRow.swift
//  Kinetica
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.primaryText)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    FeatureRow(icon: "bolt.fill",
               color: .orange,
               title: "Linear Motion",
               description: "Explore velocity and acceleration in one dimension."
           )
           .padding()
}
