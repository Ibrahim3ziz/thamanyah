//
//  SearchRepositoryTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah

final class SearchRepositoryTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockService: MockNetworkService!
    var repository: SearchRepo!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockService = MockNetworkService()
        repository = SearchRepo(networkService: mockService)
    }
    
    override func tearDown() {
        mockService.reset()
        mockService = nil
        repository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchSuccess() {
        // Given
        let mockContent = SearchContent(
            podcastId: "123",
            name: "Test Podcast",
            description: "Test Description",
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
        mockService.mockResponse = SearchDTOResponse(sections: [mockSection])
        
        // When
        let expectation = expectation(description: "Search succeeds")
        var result: SearchDTOResponse?
        var error: NetworkError?
        
        repository.search(query: "test")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let err) = completion {
                        error = err
                    }
                    expectation.fulfill()
                },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(error)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.sections.count, 1)
        XCTAssertEqual(result?.sections.first?.name, "Results")
        XCTAssertEqual(result?.sections.first?.content.count, 1)
        XCTAssertEqual(result?.sections.first?.content.first?.name, "Test Podcast")
        XCTAssertEqual(mockService.executeCallCount, 1)
    }
    
    func testSearchEmptyQuery() {
        // Given
        mockService.mockResponse = SearchDTOResponse(sections: [])
        
        // When
        let expectation = expectation(description: "Empty query returns empty sections")
        var result: SearchDTOResponse?
        
        repository.search(query: "")
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.sections.isEmpty ?? false)
        XCTAssertEqual(mockService.executeCallCount, 1)
    }
    
    func testSearchNetworkError() {
        // Given
        mockService.mockError = NetworkError(errorType: .networkFailure)
        
        // When
        let expectation = expectation(description: "Network error propagates")
        var receivedError: NetworkError?
        
        repository.search(query: "test")
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value on network failure")
                }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(mockService.executeCallCount, 1)
    }
}
