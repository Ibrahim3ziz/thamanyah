//
//  QueueCardView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct QueueCardView: View {
    let sectionContent: SectionContent?
    let stackedImages: [URL?]
    let itemCount: Int
    let totalDuration: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            // Left side - Text content
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Spacer()
                
                Text(sectionContent?.name ?? "")
                    .typography(.body)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                // Subtitle info (duration + time ago)
                HStack(spacing: 4) {
                    if let duration = sectionContent?.durationFormatted {
                        Text(duration)
                            .typography(.caption1)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                // Play button
                Button(action: {}) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: SystemIcons.play)
                                .foregroundColor(.black)
                                .font(.title3)
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Right side - Stacked images
            StackedImagesView(images: stackedImages)
        }
        .padding(20)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        
    }
}

#Preview {
    QueueCardView(
        sectionContent: mockSectionContent.first,
        stackedImages: [URL(string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg")],
        itemCount: 0,
        totalDuration: 0
    )
    .background(Color.black)
}
