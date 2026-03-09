//
//  SearchUseCaseTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah

// MARK: - Mock Search Repository
final class MockSearchRepository: SearchRepoInterface {
    
    var mockResponse: SearchDTOResponse?
    var mockError: NetworkError?
    private(set) var searchCallCount = 0
    private(set) var lastSearchQuery: String?
    
    func search(query: String) -> AnyPublisher<SearchDTOResponse, NetworkError> {
        searchCallCount += 1
        lastSearchQuery = query
        
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let response = mockResponse {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkError(errorType: .decodingError)).eraseToAnyPublisher()
    }
    
    func reset() {
        mockResponse = nil
        mockError = nil
        searchCallCount = 0
        lastSearchQuery = nil
    }
}

// MARK: - Search Use Case Tests
final class SearchUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockRepo: MockSearchRepository!
    var useCase: SearchUseCase!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockRepo = MockSearchRepository()
        useCase = SearchUseCase(repository: mockRepo)
    }
    
    override func tearDown() {
        mockRepo.reset()
        mockRepo = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchMapping() {
        // Given
        let mockContent = SearchContent(
            podcastId: "123",
            name: "Test Podcast",
            description: "Description",
            avatarUrl: "https://example.com/image.jpg",
            episodeCount: "10",
            duration: "3600",
            language: "en",
            priority: "high",
            popularityScore: "90",
            score: "95"
        )
        let mockSection = SearchSection(
            name: "Results",
            type: "list",
            contentType: "podcast",
            order: "1",
            content: [mockContent]
        )
        mockRepo.mockResponse = SearchDTOResponse(sections: [mockSection])
        
        // When
        let expectation = expectation(description: "Search maps DTO to entity")
        var entity: SearchEntity?
        
        useCase.search(query: "test")
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { entity = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(entity?.sections.count, 1)
        XCTAssertEqual(entity?.sections.first?.name, "Results")
        XCTAssertEqual(entity?.sections.first?.content.first?.name, "Test Podcast")
        XCTAssertEqual(entity?.sections.first?.content.first?.episodeCount, 10)
        XCTAssertEqual(entity?.sections.first?.content.first?.duration, 3600)
        XCTAssertEqual(mockRepo.searchCallCount, 1)
        XCTAssertEqual(mockRepo.lastSearchQuery, "test")
    }
    
    func testSearchError() {
        // Given
        mockRepo.mockError = NetworkError(errorType: .serverError)
        
        // When
        let expectation = expectation(description: "Error propagates from repo to use case")
        var receivedError: NetworkError?
        
        useCase.search(query: "test")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value on error")
                }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(mockRepo.searchCallCount, 1)
        XCTAssertEqual(mockRepo.lastSearchQuery, "test")
    }
    
    func testSearchQueryPassthrough() {
        // Given - verify query string is correctly forwarded to repo
        mockRepo.mockResponse = SearchDTOResponse(sections: [])
        
        // When
        let expectation = expectation(description: "Query forwarded to repo")
        
        useCase.search(query: "thamanyah")
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepo.lastSearchQuery, "thamanyah")
    }
    
    func testSearchEmptyResults() {
        // Given
        mockRepo.mockResponse = SearchDTOResponse(sections: [])
        
        // When
        let expectation = expectation(description: "Empty results mapped correctly")
        var entity: SearchEntity?
        
        useCase.search(query: "noresults")
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { entity = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(entity)
        XCTAssertTrue(entity?.sections.isEmpty ?? false)
        XCTAssertEqual(mockRepo.searchCallCount, 1)
    }
}
