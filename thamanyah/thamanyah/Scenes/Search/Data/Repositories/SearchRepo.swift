//
//  SearchRepo.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import NetworkKit
import Combine

final class SearchRepo: SearchRepoInterface {
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = DefaultNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - SearchRepoInterface
    func search(query: String) -> AnyPublisher<SearchDTOResponse, NetworkError> {
        networkService.execute(SearchTarget(query: query), model: SearchDTOResponse.self)
    }
}
