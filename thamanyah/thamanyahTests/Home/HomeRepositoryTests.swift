//
//  HomeRepositoryTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah

final class HomeRepositoryTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockService: MockNetworkService!
    var repository: HomeRepo!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockService = MockNetworkService()
        repository = HomeRepo(networkService: mockService)
    }
    
    override func tearDown() {
        mockService.reset()
        mockService = nil
        repository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetHomeDataSuccess() {
        // Given
        let mockSections = [
            HomeSection(
                name: "Featured",
                type: .bigSquare,
                contentType: .podcast,
                order: 1,
                content: []
            )
        ]
        mockService.mockResponse = HomeDTOResponse(
            sections: mockSections,
            pagination: Pagination(nextPage: "2", totalPages: 5)
        )
        
        // When
        let expectation = expectation(description: "Fetch home data")
        var result: HomeDTOResponse?
        var error: NetworkError?
        
        repository.getHomeData(page: 1)
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
        XCTAssertEqual(result?.sections.first?.name, "Featured")
        XCTAssertEqual(result?.pagination.totalPages, 5)
        XCTAssertEqual(result?.pagination.nextPage, "2")
        XCTAssertEqual(mockService.executeCallCount, 1) // Verify it was called once
    }
    
    func testGetHomeDataNetworkFailure() {
        // Given
        mockService.mockError = NetworkError(errorType: .networkFailure)
        
        // When
        let expectation = expectation(description: "Network failure")
        var receivedError: NetworkError?
        
        repository.getHomeData(page: 1)
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
    
    func testGetHomeDataEmptyResponse() {
        // Given
        mockService.mockResponse = HomeDTOResponse(
            sections: [],
            pagination: Pagination(nextPage: nil, totalPages: 1)
        )
        
        // When
        let expectation = expectation(description: "Empty response")
        var result: HomeDTOResponse?
        
        repository.getHomeData(page: 1)
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.sections.isEmpty ?? false)
        XCTAssertEqual(result?.pagination.totalPages, 1)
        XCTAssertNil(result?.pagination.nextPage)
        XCTAssertEqual(mockService.executeCallCount, 1)
    }
}
