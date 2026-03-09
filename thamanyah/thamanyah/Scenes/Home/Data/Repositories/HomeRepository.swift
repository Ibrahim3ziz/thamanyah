//
//  HomeRepository.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import NetworkKit
import Combine

final class HomeRepo: HomeRepoInterface {
    
    // MARK: - Depenencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = DefaultNetworkService.shared) {
        self.networkService = networkService
    }
    
    // MARK: - HomeRepoInterface
    func getHomeData(page: Int) -> AnyPublisher<HomeDTOResponse, NetworkError> {
        networkService.execute(HomeTarget(page: page), model: HomeDTOResponse.self)
    }
}
