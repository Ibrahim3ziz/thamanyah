//
//  SearchViewController.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search contents..."
        controller.searchBar.delegate = self
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.register(SearchContentCell.self, forCellReuseIdentifier: SearchContentCell.reuseIdentifier)
        table.register(SearchSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchSectionHeaderView.reuseIdentifier)
        return table
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateView: SearchEmptyStateView = {
        let view = SearchEmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupAppearance()
        setupSubviews()
        setupConstraints()
        updateUI()
    }
}

// MARK: - Private methods
extension SearchViewController {
    private func setupAppearance() {
        title = "Search"
        view.backgroundColor = .systemBackground
        
        // Setup Navigation
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(emptyStateView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading View
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        // Bind to sections changes
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        // Bind to loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        // Bind to error state
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.updateUI()
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
        
        // Bind to hasSearched state
        viewModel.$hasSearched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        let hasResults = !viewModel.sections.isEmpty
        let isLoading = viewModel.isLoading
        let hasSearched = viewModel.hasSearched
        let hasError = viewModel.errorMessage != nil
        
        // Show/Hide views based on state
        tableView.isHidden = !hasResults || isLoading
        loadingView.isHidden = !isLoading
        
        // Handle empty state
        if isLoading {
            emptyStateView.isHidden = true
        } else if hasError {
            emptyStateView.isHidden = false
            emptyStateView.configureForError(message: viewModel.errorMessage ?? "Please try again")
        } else if !hasSearched {
            emptyStateView.isHidden = false
            emptyStateView.configureForInitialSearch()
        } else if hasResults {
            emptyStateView.isHidden = true
        } else {
            emptyStateView.isHidden = false
            emptyStateView.configureForNoResults()
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchContentCell.reuseIdentifier,
            for: indexPath
        ) as? SearchContentCell else {
            return UITableViewCell()
        }
        
        let content = viewModel.sections[indexPath.section].content[indexPath.row]
        cell.configure(with: content)
        return cell
    }
}

// MARK: - UITableViewHeaderDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SearchSectionHeaderView.reuseIdentifier
        ) as? SearchSectionHeaderView else {
            return nil
        }
        
        let sectionData = viewModel.sections[section]
        headerView.configure(with: sectionData.name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.sections[section].name.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let content = viewModel.sections[indexPath.section].content[indexPath.row]
        // TODO: Handle content selection
        print("Selected: \(content.name)")
    }
}
