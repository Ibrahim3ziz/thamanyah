//
//  mocs.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//


let mockPodcast = Podcast(
    id: "1",
    name: "Tech Talk Daily",
    description: "Your daily dose of technology news",
    avatarUrl: "https://picsum.photos/240/240",
    episodeCount: 150,
    duration: 2400,
    language: "en",
    priority: 1,
    popularityScore: 95,
    score: 4.8
)

let mockAudiobook = Audiobook(
    id: "2",
    name: "The Great Adventure",
    authorName: "John Smith",
    description: "An epic journey through time",
    avatarUrl: "https://picsum.photos/241/241",
    duration: 7200,
    language: "en",
    releaseDate: "2026-01-15T10:00:00Z",
    score: 4.5
)

let mockEpisode = Episode(
    id: "3",
    name: "Introduction to SwiftUI",
    description: "Learn the basics of SwiftUI",
    avatarUrl: "https://picsum.photos/242/242",
    duration: 1800,
    audioUrl: nil,
    releaseDate: "2026-03-01T08:00:00Z",
    podcastId: "1",
    podcastName: "Tech Talk Daily",
    authorName: "Jane Doe",
    episodeType: "full",
    score: 4.9
)

let mockSectionContent: [SectionContent] = [
    .podcast(mockPodcast),
    .audiobook(mockAudiobook),
    .episode(mockEpisode)
]
