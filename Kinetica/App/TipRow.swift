//
//  TipRow.swift
//  Kinetica
//
//  Created by Ayush Ahuja on 02/05/26.
//

import SwiftUI

import SwiftUI

struct TipRow: View {
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AppTheme.primaryAccent)
                .font(.body)
            Text(tip)
                .font(.subheadline)
                .foregroundStyle(AppTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
