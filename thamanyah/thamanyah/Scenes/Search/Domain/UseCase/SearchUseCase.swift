//
//  SearchUseCase.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import Foundation
import Combine
import NetworkKit

protocol SearchUseCaseProtocol: AnyObject {
    func search(query: String) -> AnyPublisher<SearchEntity, NetworkError>
}

final class SearchUseCase {
    
    // MARK: - Dependencies
    private let repository: SearchRepoInterface
    
    // MARK: - Inits
    init(repository: SearchRepoInterface) {
        self.repository = repository
    }
}

// MARK: - SearchUseCaseProtocol
extension SearchUseCase: SearchUseCaseProtocol {
    func search(query: String) -> AnyPublisher<SearchEntity, NetworkError> {
        repository.search(query: query)
            .map { SearchEntity(dto: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
