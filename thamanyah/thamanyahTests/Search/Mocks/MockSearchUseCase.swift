//
//  MockSearchUseCase.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 10/03/2026.
//

import Combine
import NetworkKit
@testable import thamanyah

// MARK: - Mock Search Use Case
final class MockSearchUseCase: SearchUseCaseProtocol {
    
    var mockResponse: SearchEntity?
    var mockError: NetworkError?
    private(set) var searchCallCount = 0
    private(set) var lastSearchQuery: String?
    
    func search(query: String) -> AnyPublisher<SearchEntity, NetworkError> {
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
