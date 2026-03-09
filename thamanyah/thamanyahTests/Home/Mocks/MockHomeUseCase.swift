//
//  MockHomeUseCase.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 10/03/2026.
//

import Combine
import NetworkKit
@testable import thamanyah

// MARK: - Mock Home Use Case
final class MockHomeUseCase: HomeUseCaseProtocol {
    
    var mockResponse: HomeEntity?
    var mockError: NetworkError?
    private(set) var fetchHomeCallCount = 0
    private(set) var lastRequestedPage: Int?
    
    func fetchHome(page: Int) -> AnyPublisher<HomeEntity, NetworkError> {
        fetchHomeCallCount += 1
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
        fetchHomeCallCount = 0
        lastRequestedPage = nil
    }
}
