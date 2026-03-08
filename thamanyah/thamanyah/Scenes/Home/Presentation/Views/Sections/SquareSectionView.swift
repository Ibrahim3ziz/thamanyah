//
//  SquareSectionView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct SquareSectionView: View {
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
            SquareCardView(podcast: podcast)
        case .audioArticle(let article):
            SquareCardView(audioArticle: article)
        case .episode(let episode):
            SquareCardView(episode: episode)
        case .audiobook(let audiobook):
            SquareCardView(audiobook: audiobook)
        }
    }
}

#Preview {
    SquareCardView(
        imageUrl: URL(
            string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
        ),
        title: "Test title Saquare Card",
        duration: 325,
        releaseDate: Date(timeInterval: 324.324, since: .now)
    )
    .background(Color.black)
}
