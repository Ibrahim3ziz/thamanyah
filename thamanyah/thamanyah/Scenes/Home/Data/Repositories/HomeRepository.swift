//
//  HomeRepository.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import NetworkKit
import Combine

class HomeRepo: HomeRepoInterface {
    func getHomeData(page: Int) -> AnyPublisher<HomeDTOResponse, NetworkError> {
        NetworkManager.shared.execute(HomeTarget(page: page), model: HomeDTOResponse.self)
    }
}
