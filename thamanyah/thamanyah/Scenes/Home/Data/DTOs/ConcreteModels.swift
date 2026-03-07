//
//  ConcreteModels.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import Foundation

// MARK: - Concrete Models
struct Podcast: Decodable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let avatarUrl: String?
    let episodeCount: Int?
    let duration: Int?
    let language: String?
    let priority: Int?
    let popularityScore: Int?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case popularityScore, name, description, duration, language, priority, score
        case id = "podcast_id"
        case avatarUrl = "avatar_url"
        case episodeCount = "episode_count"
    }
}

struct Episode: Decodable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let avatarUrl: String?
    let duration: Int?
    let audioUrl: String?
    let releaseDate: String?
    let podcastId: String?
    let podcastName: String
    let authorName: String
    let episodeType: String?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, description, duration, score
        case id = "episode_id"
        case avatarUrl = "avatar_url"
        case audioUrl = "audio_url"
        case releaseDate = "release_date"
        case podcastId = "podcast_id"
        case podcastName = "podcast_name"
        case authorName = "author_name"
        case episodeType = "episode_type"
    }
}

struct Audiobook: Decodable, Identifiable {
    let id: String
    let name: String
    let authorName: String?
    let description: String?
    let avatarUrl: String?
    let duration: Int?
    let language: String?
    let releaseDate: String?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, description, duration, language, score
        case id = "audiobook_id"
        case authorName = "author_name"
        case avatarUrl = "avatar_url"
        case releaseDate = "release_date"
    }
}

struct AudioArticle: Decodable, Identifiable {
    let id: String
    let name: String
    let authorName: String?
    let description: String?
    let avatarUrl: String?
    let duration: Int?
    let releaseDate: String?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, description, duration, score
        case id = "article_id"
        case authorName = "author_name"
        case avatarUrl = "avatar_url"
        case releaseDate = "release_date"
    }
}
