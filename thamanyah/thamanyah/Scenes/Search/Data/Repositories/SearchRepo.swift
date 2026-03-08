//
//  SearchRepo.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import NetworkKit
import Combine

class SearchRepo: SearchRepoInterface {
    func search(query: String) -> AnyPublisher<SearchDTOResponse, NetworkError> {
        NetworkManager.shared.execute(SearchTarget(query: query), model: SearchDTOResponse.self)
    }
}
