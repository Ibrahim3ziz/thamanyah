//
//  HomeViewModelTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah


// MARK: - Home ViewModel Tests
final class HomeViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockUseCase: MockHomeUseCase!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockUseCase = MockHomeUseCase()
        viewModel = HomeViewModel(homeUseCase: mockUseCase)
    }
    
    override func tearDown() {
        mockUseCase.reset()
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadInitialData() {
        // Given
        mockUseCase.mockResponse = HomeEntity(
            sections: [
                HomeSectionEntity(name: "Featured", type: .bigSquare, contentType: .podcast, order: 1, content: [])
            ],
            nextPage: "2",
            totalPages: 5
        )
        
        // When
        let expectation = expectation(description: "Load initial data successfully")
        
        viewModel.$isLoading
            .dropFirst()
            .filter { !$0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections.first?.name, "Featured")
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPages, 5)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertEqual(mockUseCase.fetchHomeCallCount, 1)
        XCTAssertEqual(mockUseCase.lastRequestedPage, 1)
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
        
        viewModel.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertEqual(mockUseCase.fetchHomeCallCount, 1)
    }
    
    func testLoadMoreAppendsSections() {
        // Given - first load
        mockUseCase.mockResponse = HomeEntity(
            sections: [
                HomeSectionEntity(name: "Featured", type: .bigSquare, contentType: .podcast, order: 1, content: [])
            ],
            nextPage: "2",
            totalPages: 5
        )
        
        let firstLoadExpectation = expectation(description: "First page loaded")
        viewModel.$sections
            .dropFirst()
            .filter { !$0.isEmpty }
            .first()
            .sink { _ in firstLoadExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.load()
        wait(for: [firstLoadExpectation], timeout: 1.0)
        
        // Given - second load
        mockUseCase.mockResponse = HomeEntity(
            sections: [
                HomeSectionEntity(name: "Trending", type: .queue, contentType: .episode, order: 2, content: [])
            ],
            nextPage: "3",
            totalPages: 5
        )
        
        let secondLoadExpectation = expectation(description: "Second page appended")
        viewModel.$sections
            .dropFirst()
            .filter { $0.count == 2 } // Wait until both sections are present
            .first()
            .sink { _ in secondLoadExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.loadMore()
        wait(for: [secondLoadExpectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.sections.count, 2)
        XCTAssertEqual(viewModel.sections[0].name, "Featured")
        XCTAssertEqual(viewModel.sections[1].name, "Trending")
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertEqual(mockUseCase.fetchHomeCallCount, 2)
        XCTAssertEqual(mockUseCase.lastRequestedPage, 2)
    }
    
    func testCanLoadMoreFalseOnLastPage() {
        // Given
        mockUseCase.mockResponse = HomeEntity(
            sections: [],
            nextPage: nil,
            totalPages: 1
        )
        
        let expectation = expectation(description: "Last page reached")
        viewModel.$isLoading
            .dropFirst()
            .filter { !$0 }
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.totalPages, 1)
    }
}
