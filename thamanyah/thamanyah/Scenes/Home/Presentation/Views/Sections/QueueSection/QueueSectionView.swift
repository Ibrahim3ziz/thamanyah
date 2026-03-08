//
//  QueueSectionView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct QueueSectionView: View {
    let title: String
    let sectionContent: [SectionContent]
    var onSeeAll: (() -> Void)? = nil
    
    private var totalDuration: Int {
        sectionContent.compactMap { $0.duration }.reduce(0, +)
    }
    
    private var stackedImages: [URL?] {
        Array(sectionContent.prefix(4).map(\.avatarURL))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            QueueSectionHeader(
                title: title,
                itemCount: sectionContent.count,
                totalDuration: totalDuration,
                onSeeAll: onSeeAll
            )
            
            QueueCardView(
                sectionContent: sectionContent.first,
                stackedImages: stackedImages,
                itemCount: sectionContent.count,
                totalDuration: totalDuration
            )
        }
    }
}


#Preview {
    QueueSectionView(
        title: "Title",
        sectionContent: mockSectionContent
    )
    .background(Color.black)
}
