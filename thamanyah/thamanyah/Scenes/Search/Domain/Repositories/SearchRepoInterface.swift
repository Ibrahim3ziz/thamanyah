//
//  SearchRepoInterface.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import NetworkKit
import Combine

protocol SearchRepoInterface {
    func search(query: String) -> AnyPublisher<SearchDTOResponse, NetworkError>
}
