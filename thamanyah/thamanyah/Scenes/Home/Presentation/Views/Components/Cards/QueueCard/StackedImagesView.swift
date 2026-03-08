//
//  StackedImagesView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

// MARK: - Stacked Images
struct StackedImagesView: View {
    let images: [URL?]
    
    var body: some View {
        ZStack {
            ForEach(Array(images.prefix(4).enumerated()), id: \.offset) { index, url in
                AsyncImage(url: url, size: 120, cornerRadius: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.3), lineWidth: 2)
                    )
                    .offset(x: CGFloat(index) * 25)
                    .zIndex(Double(images.count - index))
            }
        }
        .frame(width: 200, height: 120)
    }
}

#Preview {
    Group {
        StackedImagesView(
            images: [
                URL(
                    string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
                )!,
                nil,
            ]
        )
    }
}
