//
//  BigSquareCardView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct BigSquareCardView: View {
    let title: String?
    let imageUrl: URL?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            AsyncImage(url: imageUrl, size: 240)
            
            // Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Text content
            Text(title ?? "")
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.leading, 12)
                .padding(.bottom, 12)
                .typography(.title3)
        }
        .aspectRatio(1, contentMode: .fit)
        .containerRelativeFrame(.horizontal) { width, _ in
            width * 0.60
        }
    }
}

// MARK: - Convenience Initializers
extension BigSquareCardView {
    init(episode: Episode) {
        self.imageUrl = URL(string: episode.avatarUrl ?? "")
        self.title = episode.name
    }
    
    init(audiobook: Audiobook) {
        self.imageUrl = URL(string: audiobook.avatarUrl ?? "")
        self.title = audiobook.name
    }
    
    init(audioArticle: AudioArticle) {
        self.imageUrl = URL(string: audioArticle.avatarUrl ?? "")
        self.title = audioArticle.name
    }
    
    init(podcast: Podcast) {
        self.imageUrl = URL(string: podcast.avatarUrl ?? "")
        self.title = podcast.name
    }
}


#Preview {
    BigSquareCardView(
        title: "Big Square Card Title",
        imageUrl:  URL(
            string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
        )
    )
}
