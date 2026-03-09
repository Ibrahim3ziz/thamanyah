//
//  SearchViewControllerRepresentable.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import SwiftUI

struct SearchViewControllerRepresentable: UIViewControllerRepresentable {
    
    let viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let searchViewController = SearchViewController(viewModel: viewModel)
        
        // Add close button
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: context.coordinator,
            action: #selector(Coordinator.dismissView)
        )
        searchViewController.navigationItem.leftBarButtonItem = closeButton
        
        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }
    
    class Coordinator: NSObject {
        let dismiss: DismissAction
        
        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }
        
        @objc func dismissView() {
            dismiss()
        }
    }
}
