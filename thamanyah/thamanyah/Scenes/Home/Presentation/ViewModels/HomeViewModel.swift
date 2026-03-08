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
    
    // MARK: - Actions
    func load() {
        isLoading = true
        errorMessage = nil
        
        homeUseCase.fetchHome()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] entity in
                self?.sections = entity.sections.sorted { $0.order < $1.order }
            }
            .store(in: &cancellables)
    }
}
