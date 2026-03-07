//
//  ContentItem.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import Foundation

// MARK: - Content Item
enum ContentItem: Identifiable {
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
    
    var durationFormatted: String? {
        let seconds: Int?
        switch self {
        case .podcast(let p):
            seconds = p.duration
        case .episode(let e):
            seconds = e.duration
        case .audiobook(let b):
            seconds = b.duration
        case .audioArticle(let a):
            seconds = a.duration
        }
        guard let s = seconds, s > 0 else { return nil }
        let mins = s / 60
        guard mins >= 60 else { return "\(mins) min" }
        let h = mins / 60; let m = mins % 60
        return m > 0 ? "\(h)h \(m)m" : "\(h)h"
    }
}

extension ContentItem: Equatable {
    static func == (lhs: ContentItem, rhs: ContentItem) -> Bool {
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
