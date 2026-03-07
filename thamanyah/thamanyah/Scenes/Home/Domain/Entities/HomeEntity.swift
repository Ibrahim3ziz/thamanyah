//
//  HomeEntity.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import Foundation

// MARK: - HomeEntity (Domain)
struct HomeEntity: Equatable {
    let sections: [HomeSectionEntity]
    let nextPage: String?
    let totalPages: Int
}

// MARK: - Section Entity
struct HomeSectionEntity: Identifiable, Equatable {
    var id: String { "\(name)-\(order)" }
    let name: String
    let type: SectionDisplayType
    let contentType: ContentType
    let order: Int
    let content: [ContentItem]
}
