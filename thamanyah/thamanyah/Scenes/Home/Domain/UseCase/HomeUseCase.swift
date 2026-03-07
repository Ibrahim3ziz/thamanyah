//
//  HomeUseCase.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//
import Foundation
import Combine
import NetworkKit

protocol HomeUseCaseProtocol: AnyObject {
    func fetchHome() -> AnyPublisher<HomeEntity, NetworkError>
}

final class HomeUseCase {
    
    // MARK: - Dependencies
    private let repository: HomeRepoInterface
    
    // MARK: - Inits
    init(
        repository: HomeRepoInterface
    ) {
        self.repository = repository
    }
}

// MARK: - HomeUseCaseProtocol
extension HomeUseCase: HomeUseCaseProtocol {
    func fetchHome() -> AnyPublisher<HomeEntity, NetworkError> {
        repository.getHomeData()
            .map { HomeEntity(dto: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
