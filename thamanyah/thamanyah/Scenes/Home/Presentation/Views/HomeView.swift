//
//  HomeView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 06/03/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: @autoclosure @escaping () -> HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let message = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Something went wrong")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        viewModel.load()
                    }
                }
                .padding()
            } else if viewModel.sections.isEmpty {
                ContentUnavailableView("No content", systemImage: SystemIcons.empty3D)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(viewModel.sections) { section in
                            sectionView(for: section)
                                .onAppear {
                                    // Trigger pagination when the last section appears
                                    if section.id == viewModel.sections.last?.id {
                                        viewModel.loadMore()
                                    }
                                }
                        }
                        
                        // Loading indicator for pagination
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
        .task { viewModel.load() }
    }
    
    @ViewBuilder
    private func sectionView(for section: HomeSectionEntity) -> some View {
        switch section.type {
        case .queue:
            QueueSectionView(
                title: section.name,
                sectionContent: section.content,
                onSeeAll: { handleSeeAll(for: section) }
            )
        case .square:
            SquareSectionView(
                title: section.name,
                sectionContent: section.content,
                onSeeAll: { handleSeeAll(for: section) }
            )
        case .twoLinesGrid:
            TwoColumnGridSectionView(
                title: section.name,
                sectionContent: section.content,
                onSeeAll: { handleSeeAll(for: section) }
            )
        case .bigSquare:
            BigSquareSectionView(
                title: section.name,
                sectionContent: section.content,
                onSeeAll: { handleSeeAll(for: section) }
            )
        case .unknown:
            EmptyView()
        }
    }
    
    private func handleSeeAll(for section: HomeSectionEntity) {
        // TODO: Wire up navigation
    }
}
