//
//  SearchEntity.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import Foundation

// MARK: - SearchEntity (Domain)
struct SearchEntity: Equatable {
    let sections: [SearchSectionEntity]
}

// MARK: - SearchSectionEntity
struct SearchSectionEntity: Identifiable, Equatable {
    var id: String { "\(name)-\(order)" }
    let name: String
    let type: String
    let contentType: String
    let order: String
    let content: [SearchContentEntity]
}

// MARK: - SearchContentEntity
struct SearchContentEntity: Identifiable, Equatable {
    let podcastId: String
    let name: String
    let description: String
    let avatarUrl: String
    let episodeCount: Int
    let duration: Int
    let language: String
    let priority: String
    let popularityScore: String
    let score: String
    
    var id: String { podcastId }
}

// MARK: - Mapping from DTO to Entity
extension SearchEntity {
    init(dto: SearchDTOResponse) {
        self.sections = dto.sections.map { section in
            SearchSectionEntity(
                name: section.name,
                type: section.type,
                contentType: section.contentType,
                order: section.order,
                content: section.content.map { content in
                    SearchContentEntity(
                        podcastId: content.podcastId,
                        name: content.name,
                        description: content.description,
                        avatarUrl: content.avatarUrl,
                        episodeCount: Int(content.episodeCount) ?? 0,
                        duration: Int(content.duration) ?? 0,
                        language: content.language,
                        priority: content.priority,
                        popularityScore: content.popularityScore,
                        score: content.score
                    )
                }
            )
        }
    }
}
