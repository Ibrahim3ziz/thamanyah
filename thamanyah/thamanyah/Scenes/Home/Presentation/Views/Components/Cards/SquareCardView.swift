//
//  SquareCardView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct SquareCardView: View {
    let imageUrl: URL?
    let title: String?
    let duration: Int?
    let releaseDate: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Image
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: imageUrl, size: 140)
                
                // Logo
                Image( .logo)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.black)
                    .padding(8)
            }
            
            // Title
            Text(title ?? "")
                .typography(.body)
                .foregroundColor(.black)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
                .frame(width: 140, alignment: .leading)
            
            // Duration View + Relative Date
            HStack(spacing: 8) {
                // Duration View
                if let duration = duration {
                    DurationView(duration: duration)
                }
                
                // Relative Date
                if let date = releaseDate {
                    Text(date, style: .relative)
                        .foregroundColor(.black)
                }
                
            }
        }
    }
}

// MARK: - Convenience Initializers
extension SquareCardView {
    init(episode: Episode) {
        self.imageUrl = URL(string: episode.avatarUrl ?? "")
        self.title = episode.name
        self.duration = episode.duration
        self.releaseDate = ISO8601DateParser.parse(episode.releaseDate)
    }
    
    init(audiobook: Audiobook) {
        self.imageUrl = URL(string: audiobook.avatarUrl ?? "")
        self.title = audiobook.name
        self.duration = audiobook.duration
        self.releaseDate = ISO8601DateParser.parse(audiobook.releaseDate)
        
    }
    
    init(audioArticle: AudioArticle) {
        self.imageUrl = URL(string: audioArticle.avatarUrl ?? "")
        self.title = audioArticle.name
        self.duration = audioArticle.duration
        self.releaseDate = ISO8601DateParser.parse(audioArticle.releaseDate)
    }
    
    init(podcast: Podcast) {
        self.imageUrl = URL(string: podcast.avatarUrl ?? "")
        self.title = podcast.name
        self.duration = podcast.duration
        self.releaseDate = nil
    }
}


// MARK: - Preview
#Preview {
    SquareCardView(
        imageUrl: URL(
            string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
        ),
        title: "Test podcast title",
        duration: 266195,
        releaseDate: nil
    )
    .background(.black)
}
