//
//  SectionContent.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import Foundation

// MARK: - Content Item
enum SectionContent: Identifiable {
    case podcast(Podcast)
    case episode(Episode)
    case audiobook(Audiobook)
    case audioArticle(AudioArticle)
    
    var id: String {
        switch self {
        case .podcast(let p):
            return p.id
        case .episode(let e):
            return e.id
        case .audiobook(let b):
            return b.id
        case .audioArticle(let a):
            return a.id
        }
    }
    
    var name: String {
        switch self {
        case .podcast(let p):
            return p.name
        case .episode(let e):
            return e.name
        case .audiobook(let b):
            return b.name
        case .audioArticle(let a):
            return a.name
        }
    }
    
    var avatarURL: URL? {
        let raw: String?
        switch self {
        case .podcast(let p):
            raw = p.avatarUrl
        case .episode(let e):
            raw = e.avatarUrl
        case .audiobook(let b):
            raw = b.avatarUrl
        case .audioArticle(let a):
            raw = a.avatarUrl
        }
        return raw.flatMap(URL.init)
    }
    
    var subtitle: String? {
        switch self {
        case .podcast(let p):
            return p.episodeCount.map { "\($0) episodes" }
        case .episode(let e):
            return e.podcastName.isEmpty ? nil : e.podcastName
        case .audiobook(let b):
            return b.authorName
        case .audioArticle(let a):
            return a.authorName
        }
    }
    
    var duration: Int? {
        switch self {
        case .podcast(let podcast):
            return podcast.duration
        case .episode(let episode):
            return episode.duration
        case .audiobook(let audiobook):
            return audiobook.duration
        case .audioArticle(let audioArticle):
            return audioArticle.duration
        }
    }
    
    var durationFormatted: String? {
        let raw: String?
        switch self {
        case .podcast(let p):
            raw = Formatters.briefHM.string(from: TimeInterval(p.duration ?? 0))
        case .episode(let e):
            raw = Formatters.briefHM.string(from: TimeInterval(e.duration ?? 0))
        case .audiobook(let b):
            raw = Formatters.briefHM.string(from: TimeInterval(b.duration ?? 0))
        case .audioArticle(let a):
            raw = Formatters.briefHM.string(from: TimeInterval(a.duration ?? 0))
        }
        return raw
    }    
}

extension SectionContent: Equatable {
    static func == (lhs: SectionContent, rhs: SectionContent) -> Bool {
        switch (lhs, rhs) {
        case let (.podcast(a), .podcast(b)):
            return a.id == b.id
        case let (.episode(a), .episode(b)):
            return a.id == b.id
        case let (.audiobook(a), .audiobook(b)):
            return a.id == b.id
        case let (.audioArticle(a), .audioArticle(b)):
            return a.id == b.id
        default:
            return false
        }
    }
}
