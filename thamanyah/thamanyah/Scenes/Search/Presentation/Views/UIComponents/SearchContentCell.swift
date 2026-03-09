//
//  SearchContentCell.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import UIKit

final class SearchContentCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchContentCell"
    
    // MARK: - UI Components
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 12
        return stack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.headline)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var metadataStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    private lazy var episodeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.typography(.caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup subviews
    private func setupSubviews() {
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(avatarImageView)
        containerStackView.addArrangedSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(metadataStackView)
        
        metadataStackView.addArrangedSubview(episodeCountLabel)
        metadataStackView.addArrangedSubview(durationLabel)
    }
    
    // MARK: - Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container Stack
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Avatar Image
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: - Configuration
    func configure(with content: SearchContentEntity) {
        titleLabel.text = content.name
        descriptionLabel.text = content.description
        
        // Episode Count
        configureEpisodeCount(content.episodeCount)
        
        // Duration
        configureDuration(content.duration)
        
        // Load Image
        avatarImageView.loadImage(from: content.avatarUrl)
    }
    
    private func configureEpisodeCount(_ count: Int) {
        let attributedText = createAttributedString(
            icon: "mic.fill",
            text: "\(count)"
        )
        episodeCountLabel.attributedText = attributedText
    }
    
    private func configureDuration(_ seconds: Int) {
        guard seconds > 0 else {
            durationLabel.isHidden = true
            return
        }
        
        let attributedText = createAttributedString(
            icon: SystemIcons.duration,
            text: Formatters.briefHM.string(from: TimeInterval(seconds)) ?? "0m"
        )
        durationLabel.attributedText = attributedText
        durationLabel.isHidden = false
    }
    
    private func createAttributedString(
        icon: String,
        text: String
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        if let image = UIImage(systemName: icon) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            attributedString.append(NSAttributedString(string: " "))
        }
        
        attributedString.append(NSAttributedString(string: text))
        return attributedString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        episodeCountLabel.text = nil
        durationLabel.text = nil
    }
}
