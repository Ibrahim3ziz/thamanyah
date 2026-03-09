//
//  HomeUseCaseTests.swift
//  thamanyahTests
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import XCTest
import Combine
import NetworkKit
@testable import thamanyah

// MARK: - Mock Home Repository
final class MockHomeRepository: HomeRepoInterface {
    
    var mockResponse: HomeDTOResponse?
    var mockError: NetworkError?
    private(set) var getHomeDataCallCount = 0
    private(set) var lastRequestedPage: Int?
    
    func getHomeData(page: Int) -> AnyPublisher<HomeDTOResponse, NetworkError> {
        getHomeDataCallCount += 1
        lastRequestedPage = page
        
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
        getHomeDataCallCount = 0
        lastRequestedPage = nil
    }
}

// MARK: - Home Use Case Tests
final class HomeUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockRepo: MockHomeRepository!
    var useCase: HomeUseCase!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockRepo = MockHomeRepository()
        useCase = HomeUseCase(repository: mockRepo)
    }
    
    override func tearDown() {
        mockRepo.reset()
        mockRepo = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchHomeMapping() {
        // Given
        let mockSections = [
            HomeSection(
                name: "Featured",
                type: .bigSquare,
                contentType: .podcast,
                order: 1,
                content: []
            ),
            HomeSection(
                name: "Trending",
                type: .queue,
                contentType: .episode,
                order: 2,
                content: []
            )
        ]
        mockRepo.mockResponse = HomeDTOResponse(
            sections: mockSections,
            pagination: Pagination(nextPage: "2", totalPages: 5)
        )
        
        // When
        let expectation = expectation(description: "Fetch home maps DTO to entity")
        var entity: HomeEntity?
        
        useCase.fetchHome(page: 1)
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { entity = $0 }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(entity?.sections.count, 2)
        XCTAssertEqual(entity?.totalPages, 5)
        XCTAssertEqual(entity?.nextPage, "2")
        XCTAssertEqual(entity?.sections[0].name, "Featured")
        XCTAssertEqual(entity?.sections[1].name, "Trending")
        XCTAssertEqual(mockRepo.getHomeDataCallCount, 1)
        XCTAssertEqual(mockRepo.lastRequestedPage, 1)
    }
    
    func testFetchHomeError() {
        // Given
        mockRepo.mockError = NetworkError(errorType: .serverError)
        
        // When
        let expectation = expectation(description: "Error propagates from repo to use case")
        var receivedError: NetworkError?
        
        useCase.fetchHome(page: 1)
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
        XCTAssertEqual(mockRepo.getHomeDataCallCount, 1)
        XCTAssertEqual(mockRepo.lastRequestedPage, 1)
    }
    
    func testFetchHomePaginationPassthrough() {
        // Given - verify page number is correctly forwarded to repo
        mockRepo.mockResponse = HomeDTOResponse(
            sections: [],
            pagination: Pagination(nextPage: "4", totalPages: 10)
        )
        
        // When
        let expectation = expectation(description: "Page number forwarded to repo")
        
        useCase.fetchHome(page: 3)
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockRepo.lastRequestedPage, 3)
    }
}
