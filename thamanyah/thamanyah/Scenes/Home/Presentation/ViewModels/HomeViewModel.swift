//
//  HomeViewModel.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Published State
    @Published var sections: [HomeSectionEntity] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Inits
    init(
        homeUseCase: HomeUseCaseProtocol
    ) {
        self.homeUseCase = homeUseCase
    }
    
}
