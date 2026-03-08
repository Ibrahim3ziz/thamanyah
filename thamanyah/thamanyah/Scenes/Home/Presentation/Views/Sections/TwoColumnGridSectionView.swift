//
//  TwoColumnGridSectionView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct TwoColumnGridSectionView: View {
    let title: String
    let sectionContent: [SectionContent]
    var onSeeAll: (() -> Void)? = nil
    
    private var columns: [[SectionContent]] {
        sectionContent.chunked(into: 2)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: title, onTap: onSeeAll)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                        TwoColumnGridView(items: column)
                    }
                }
            }
        }
    }
}

#Preview {
    TwoColumnGridSectionView(
        title: "Test Two Column Grid Section View",
        sectionContent: mockSectionContent
    )
    .background(Color.white)
}
