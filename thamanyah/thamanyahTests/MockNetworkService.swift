//
//  MockNetworkService.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 10/03/2026.
//

import Combine
import NetworkKit
@testable import thamanyah

final class MockNetworkService: NetworkServiceProtocol {
    
    var mockError: NetworkError?
    var mockResponse: Any?                    // generic fallback
    var requestHandlers: [String: Any] = [:] // per-endpoint override
    
    private(set) var executeCallCount = 0
    private(set) var lastExecutedTarget: BaseRequest?
    
    func execute<T: Decodable>(_ target: BaseRequest, model: T.Type) -> AnyPublisher<T, NetworkError> {
        executeCallCount += 1
        lastExecutedTarget = target
        
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // Per-endpoint takes priority, falls back to generic mockResponse
        let response = requestHandlers[target.path] as? T ?? mockResponse as? T
        
        if let response {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkError(errorType: .decodingError))
            .eraseToAnyPublisher()
    }
    
    func reset() {
        mockError = nil
        mockResponse = nil
        requestHandlers = [:]
        executeCallCount = 0
        lastExecutedTarget = nil
    }
}
