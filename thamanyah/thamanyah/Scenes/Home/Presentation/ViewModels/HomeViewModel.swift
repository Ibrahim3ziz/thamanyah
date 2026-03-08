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
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Pagination State
    @Published private(set) var currentPage: Int = 1
    @Published private(set) var totalPages: Int = 1
    @Published private(set) var canLoadMore: Bool = false
    
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
        currentPage = 1
        sections = []
        
        homeUseCase.fetchHome(page: currentPage)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] entity in
                guard let self = self else { return }
                self.sections = entity.sections.sorted { $0.order < $1.order }
                self.totalPages = entity.totalPages
                self.canLoadMore = self.currentPage < entity.totalPages
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        guard canLoadMore, !isLoadingMore else { return }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        homeUseCase.fetchHome(page: nextPage)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoadingMore = false
                if case let .failure(error) = completion {
                    print("Pagination error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] entity in
                guard let self = self else { return }
                // Append new sections to existing ones
                let newSections = entity.sections.sorted { $0.order < $1.order }
                self.sections.append(contentsOf: newSections)
                self.currentPage = nextPage
                self.totalPages = entity.totalPages
                self.canLoadMore = self.currentPage < entity.totalPages
            }
            .store(in: &cancellables)
    }
}
