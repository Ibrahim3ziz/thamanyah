//
//  MockHomeRepository.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 10/03/2026.
//

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
