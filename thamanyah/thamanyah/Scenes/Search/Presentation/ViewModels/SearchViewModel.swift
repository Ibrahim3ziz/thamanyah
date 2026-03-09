//
//  SearchViewModel.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 08/03/2026.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let searchUseCase: SearchUseCaseProtocol
    
    // MARK: - Published State
    @Published var searchQuery: String = ""
    @Published var sections: [SearchSectionEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasSearched: Bool = false
    
    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    // MARK: - Inits
    init(searchUseCase: SearchUseCaseProtocol) {
        self.searchUseCase = searchUseCase
        setupSearchDebounce()
    }
    
    // MARK: - Setup Debounce
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    private func performSearch(query: String) {
        // Cancel previous search
        searchCancellable?.cancel()
        
        // Clear results if query is empty
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            sections = []
            hasSearched = false
            errorMessage = nil
            return
        }
        
        isLoading = true
        errorMessage = nil
        hasSearched = true
        
        searchCancellable = searchUseCase.search(query: query)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.sections = []
                }
            } receiveValue: { [weak self] entity in
                guard let self = self else { return }
                self.sections = entity.sections
            }
        
        searchCancellable?.store(in: &cancellables)
    }
    
    func search() {
        performSearch(query: searchQuery)
    }
}
