//
//  SearchViewModelTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah


// MARK: - Search ViewModel Tests
final class SearchViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockUseCase: MockSearchUseCase!
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockUseCase = MockSearchUseCase()
        viewModel = SearchViewModel(searchUseCase: mockUseCase)
    }
    
    override func tearDown() {
        mockUseCase.reset()
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testEmptyQuerySkipsSearch() {
        // Given
        mockUseCase.mockResponse = SearchEntity(
            sections: [
                SearchSectionEntity(name: "Results", type: "list", contentType: "podcast", order: "1", content: [])
            ]
        )
        
        // When
        viewModel.searchQuery = ""
        
        // Then
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertFalse(viewModel.hasSearched)
        XCTAssertEqual(mockUseCase.searchCallCount, 0) // Use case should never be called
    }
    
    func testSuccessfulSearch() {
        // Given
        let mockContent = SearchContentEntity(
            podcastId: "123",
            name: "Test Podcast",
            description: "Description",
            avatarUrl: "https://example.com/image.jpg",
            episodeCount: 10,
            duration: 3600,
            language: "en",
            priority: "high",
            popularityScore: "90",
            score: "95"
        )
        mockUseCase.mockResponse = SearchEntity(
            sections: [
                SearchSectionEntity(name: "Results", type: "list", contentType: "podcast", order: "1", content: [mockContent])
            ]
        )
        
        // When
        let expectation = expectation(description: "Search returns results")
        
        viewModel.$sections
            .dropFirst()
            .filter { !$0.isEmpty }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "test"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections.first?.name, "Results")
        XCTAssertEqual(viewModel.sections.first?.content.count, 1)
        XCTAssertEqual(viewModel.sections.first?.content.first?.name, "Test Podcast")
        XCTAssertTrue(viewModel.hasSearched)
        XCTAssertEqual(mockUseCase.searchCallCount, 1)
        XCTAssertEqual(mockUseCase.lastSearchQuery, "test")
    }
    
    func testErrorHandling() {
        // Given
        mockUseCase.mockError = NetworkError(errorType: .serverError)
        
        // When
        let expectation = expectation(description: "Error message set on failure")
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "test"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertEqual(mockUseCase.searchCallCount, 1)
        XCTAssertEqual(mockUseCase.lastSearchQuery, "test")
    }
    
    func testSearchQueryPassthrough() {
        // Given
        mockUseCase.mockResponse = SearchEntity(sections: [])
        
        // When
        let expectation = expectation(description: "Query forwarded to use case")
        
        viewModel.$hasSearched
            .dropFirst()
            .filter { $0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "thamanyah"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockUseCase.lastSearchQuery, "thamanyah")
    }
    
    func testNewQueryClearsPreviousResults() {
        // Given - first search
        mockUseCase.mockResponse = SearchEntity(
            sections: [
                SearchSectionEntity(name: "First Results", type: "list", contentType: "podcast", order: "1", content: [])
            ]
        )
        
        let firstExpectation = expectation(description: "First search completes")
        viewModel.$sections
            .dropFirst()
            .filter { !$0.isEmpty }
            .first()
            .sink { _ in firstExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "first"
        wait(for: [firstExpectation], timeout: 1.0)
        
        // Given - second search returns empty
        mockUseCase.mockResponse = SearchEntity(sections: [])
        
        let secondExpectation = expectation(description: "Second search clears results")
        viewModel.$sections
            .dropFirst()
            .filter { $0.isEmpty }
            .first()
            .sink { _ in secondExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "noresults"
        wait(for: [secondExpectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertEqual(mockUseCase.searchCallCount, 2)
    }
}
