//
//  HomeDTO.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import Foundation

// MARK: - HomeDTOResponse
struct HomeDTOResponse: Decodable {
    let sections: [HomeSection]
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Decodable {
    let nextPage: String?
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
}

// MARK: - Section
struct HomeSection: Decodable, Identifiable {
    var id: String { "\(name)-\(order)" } // custom id
    let name: String
    let type: SectionDisplayType
    let contentType: ContentType
    let order: Int
    let content: [SectionContent]
    
    enum CodingKeys: String, CodingKey {
        case name, type, order, content
        case contentType = "content_type"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        type = try c.decode(SectionDisplayType.self, forKey: .type)
        contentType = try c.decode(ContentType.self, forKey: .contentType)
        order = try c.decode(Int.self, forKey: .order)
        
        // Decode content heterogeneously using the section's own contentType
        // Each element is decoded into the correct concrete model.
        var arrayContainer = try c.nestedUnkeyedContainer(forKey: .content)
        var items: [SectionContent] = []
        while !arrayContainer.isAtEnd {
            switch contentType {
            case .podcast:
                items.append(.podcast(try arrayContainer.decode(Podcast.self)))
            case .episode:
                items.append(.episode(try arrayContainer.decode(Episode.self)))
            case .audioBook:
                items.append(.audiobook(try arrayContainer.decode(Audiobook.self)))
            case .audioArticle:
                items.append(.audioArticle(try arrayContainer.decode(AudioArticle.self)))
            case .unknown:
                _ = try arrayContainer.decode(AnyCodable.self)
            }
        }
        content = items
    }
    
    // MARK: - Init
    init(name: String,
         type: SectionDisplayType,
         contentType: ContentType,
         order: Int,
         content: [SectionContent]) {
        self.name = name
        self.type = type
        self.contentType = contentType
        self.order = order
        self.content = content
    }
}

// MARK: - Display Type
enum SectionDisplayType: String, Decodable, Equatable {
    case queue, square, unknown
    case twoLinesGrid = "2_lines_grid"
    case bigSquare = "big_square"
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        let normalised = raw.replacingOccurrences(of: " ", with: "_")
        self = SectionDisplayType(rawValue: normalised) ?? .unknown
    }
}

// MARK: - Content Type
enum ContentType: String, Decodable, Equatable {
    case podcast, episode, unknown
    case audioBook = "audio_book"
    case audioArticle = "audio_article"
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = ContentType(rawValue: raw) ?? .unknown
    }
    
    var displayName: String {
        switch self {
        case .podcast:
            return "Podcasts"
        case .episode:
            return "Episodes"
        case .audioBook:
            return "Audiobooks"
        case .audioArticle:
            return "Audio Articles"
        case .unknown:
            return ""
        }
    }
}


// MARK: - AnyCodable
/// Silently consumes any unknown JSON value so decoding doesn't throw.
private struct AnyCodable: Decodable {
    init(from decoder: Decoder) throws {
        _ = try? decoder.singleValueContainer()
    }
}
