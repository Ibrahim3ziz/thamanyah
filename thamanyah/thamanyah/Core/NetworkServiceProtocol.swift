//
//  NetworkServiceProtocol.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import NetworkKit
import Combine

/// Protocol for network service to enable dependency injection and testing
protocol NetworkServiceProtocol {
    func execute<T: Decodable>(_ target: BaseRequest, model: T.Type) -> AnyPublisher<T, NetworkError>
}

/// Default implementation using NetworkManager
final class DefaultNetworkService: NetworkServiceProtocol {
    
    static let shared = DefaultNetworkService()
    
    private init() {}
    
    func execute<T: Decodable>(_ target: BaseRequest, model: T.Type) -> AnyPublisher<T, NetworkError> {
        NetworkManager.shared.execute(target, model: model)
    }
}
