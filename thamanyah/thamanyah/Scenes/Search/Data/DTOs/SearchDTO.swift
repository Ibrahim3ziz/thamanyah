//
//  SearchDTO.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import Foundation

// MARK: - SearchDTOResponse
struct SearchDTOResponse: Decodable {
    let sections: [SearchSection]
}

// MARK: - SearchSection
struct SearchSection: Decodable, Identifiable {
    var id: String { "\(name)-\(order)" } // custom id
    let name: String
    let type: String
    let contentType: String
    let order: String
    let content: [SearchContent]
    
    enum CodingKeys: String, CodingKey {
        case name, type, order, content
        case contentType = "content_type"
    }
}

// MARK: - SearchContent
struct SearchContent: Decodable, Identifiable {
    let podcastId: String
    let name: String
    let description: String
    let avatarUrl: String
    let episodeCount: String
    let duration: String
    let language: String
    let priority: String
    let popularityScore: String
    let score: String
    
    var id: String { podcastId }
    
    enum CodingKeys: String, CodingKey {
        case podcastId = "podcast_id"
        case name
        case description
        case avatarUrl = "avatar_url"
        case episodeCount = "episode_count"
        case duration
        case language
        case priority
        case popularityScore
        case score
    }
}
