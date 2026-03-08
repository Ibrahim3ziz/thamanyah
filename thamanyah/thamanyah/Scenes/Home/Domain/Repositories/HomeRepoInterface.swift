//
//  HomeRepoInterface.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import NetworkKit
import Combine

protocol HomeRepoInterface {
    func getHomeData(page: Int) -> AnyPublisher<HomeDTOResponse, NetworkError>
}
