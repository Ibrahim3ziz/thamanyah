//
//  BigSquareSectionView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct BigSquareSectionView: View {
    let title: String
    let sectionContent: [SectionContent]
    var onSeeAll: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: title, onTap: onSeeAll)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(Array(sectionContent.enumerated()), id: \.offset) { _, item in
                        cardView(for: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func cardView(for item: SectionContent) -> some View {
        switch item {
        case .podcast(let podcast):
            BigSquareCardView(podcast: podcast)
        case .audioArticle(let article):
            BigSquareCardView(audioArticle: article)
        case .episode(let episode):
            BigSquareCardView(episode: episode)
        case .audiobook(let audiobook):
            BigSquareCardView(audiobook: audiobook)
        }
    }
}

#Preview {
    return BigSquareSectionView(
        title: "Featured Content",
        sectionContent: mockSectionContent
    )
    .background(Color.black)
}
