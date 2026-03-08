//
//  GridCardView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct GridCardView: View {
    let imageUrl: URL?
    let title: String?
    let duration: Int?
    let releaseDate: Date?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image
            VStack {
                AsyncImage(url: imageUrl, size: 80, cornerRadius: 12)
                Spacer(minLength: 0)
            }
            
            // Middle - text content
            VStack(alignment: .leading, spacing: 8) {
                // Relative date
                if let date = releaseDate {
                    Text(date, style: .relative)
                        .foregroundColor(.gray)
                }
                
                // Title
                Text(title ?? "")
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Action buttons
                HStack(spacing: 12) {
                    // Duration View
                    if let duration {
                        DurationView(duration: duration)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: SystemIcons.insert)
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    
                    ShareLink(item: title ?? "") {
                        Image(systemName: SystemIcons.ellipsis)
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

// MARK: - Convenience Initializers
extension GridCardView {
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


#Preview {
    VStack(spacing: 0) {
        GridCardView(
            imageUrl: URL(
                string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
            ),
            title: "Grid Card Title",
            duration: 21532,
            releaseDate: Date(timeInterval: 324.324, since: .now)
        )
        
        Divider().background(.black)
        
        GridCardView(
            imageUrl: URL(
                string: "https://media.npr.org/assets/img/2018/08/03/npr_tbl_podcasttile_sq-284e5618e2b2df0f3158b076d5bc44751e78e1b6.jpg?s=1400&c=66&f=jpg"
            ),
            title: "Grid Card Title",
            duration: 21532,
            releaseDate: Date(timeInterval: 324.324, since: .now)
        )
    }
    .background(Color.black)
}
