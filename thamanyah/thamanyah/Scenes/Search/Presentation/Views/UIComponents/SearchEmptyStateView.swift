//
//  SearchEmptyStateView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import UIKit

final class SearchEmptyStateView: UIView {
    
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.title2)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.body)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Stack View
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),
            
            // Image View
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: - Configuration
    
    /// Configure the empty state view with image, title, and description
    /// - Parameters:
    ///   - image: The SF Symbol or image to display
    ///   - title: The title text
    ///   - description: The description text
    func configure(image: UIImage?, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    /// Configure with system image name
    /// - Parameters:
    ///   - systemName: SF Symbol name
    ///   - title: The title text
    ///   - description: The description text
    func configure(systemName: String, title: String, description: String) {
        let image = UIImage(systemName: systemName)
        configure(image: image, title: title, description: description)
    }
}

// MARK: - Empty State Presets
extension SearchEmptyStateView {
    
    /// Configure for initial search state
    func configureForInitialSearch() {
        configure(
            systemName: "magnifyingglass",
            title: "Search Contents",
            description: "Enter a search term to find contents"
        )
    }
    
    /// Configure for no results state
    func configureForNoResults() {
        configure(
            systemName: "magnifyingglass",
            title: "No Results",
            description: "Try a different search term"
        )
    }
    
    /// Configure for error state
    /// - Parameter message: The error message to display
    func configureForError(message: String) {
        configure(
            systemName: "exclamationmark.triangle",
            title: "Something went wrong",
            description: message
        )
    }
}
