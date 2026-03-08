//
//  TwoColumnGridView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct TwoColumnGridView: View {
    let items: [SectionContent]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                GridCardItem(item: item)
            }
        }
        .containerRelativeFrame(.horizontal) { width, _ in
            width - 60
        }
    }
}

// MARK: - Grid Card Item
private struct GridCardItem: View {
    let item: SectionContent
    
    var body: some View {
        switch item {
        case .episode(let episode):
            GridCardView(episode: episode)
        case .audiobook(let audiobook):
            GridCardView(audiobook: audiobook)
        case .audioArticle(let audioArticle):
            GridCardView(audioArticle: audioArticle)
        case .podcast(let podcast):
            GridCardView(podcast: podcast)
        }
    }
}

#Preview {
    TwoColumnGridView(items: mockSectionContent)
        .background(Color.black)
}
