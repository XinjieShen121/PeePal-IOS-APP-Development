//
//  MyRatingsTableViewCell.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/30/24.
//


import UIKit

class MyRatingsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyRatingsCell"

    // MARK: - UI Components
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let starStackView = UIStackView()
    private let ratingNumberLabel = UILabel()
    private let addressLabel = UILabel()
    private let myRatingLabel = UILabel()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Light background
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Container view styling
        containerView.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0) // Slightly softer white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Name label styling
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 20) // Modern font
        nameLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Dark gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Star stack view for rating stars
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.distribution = .fill
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(starStackView)

        // Rating number label styling
        ratingNumberLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        ratingNumberLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0) // Neutral gray
        ratingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ratingNumberLabel)

        // Address label styling
        addressLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        addressLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Softer gray
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addressLabel)

        // My rating label styling
        myRatingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16) // Slightly bold
        myRatingLabel.textColor = UIColor(red: 0.1, green: 0.4, blue: 0.7, alpha: 1.0) // Subtle blue
        myRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(myRatingLabel)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),

            // Star stack view constraints
            starStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            starStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            starStackView.heightAnchor.constraint(equalToConstant: 20),

            // Rating number label constraints
            ratingNumberLabel.centerYAnchor.constraint(equalTo: starStackView.centerYAnchor),
            ratingNumberLabel.leadingAnchor.constraint(equalTo: starStackView.trailingAnchor, constant: 8),
            ratingNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),

            // Address label constraints
            addressLabel.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // My rating label constraints
            myRatingLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
            myRatingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            myRatingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            myRatingLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configure Cell
    func configure(with toilet: Toilet) {
        nameLabel.text = toilet.name
        ratingNumberLabel.text = "\(toilet.rating) / 5"

        // Clear existing stars
        starStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add stars based on rating
        let maxStars = 5
        let filledStars = Int(toilet.rating)
        let hasHalfStar = toilet.rating - Double(filledStars) >= 0.5
        let emptyStars = maxStars - filledStars - (hasHalfStar ? 1 : 0)

        for _ in 0..<filledStars {
            starStackView.addArrangedSubview(createStarImage(isFilled: true))
        }

        if hasHalfStar {
            starStackView.addArrangedSubview(createStarImage(isHalf: true))
        }

        for _ in 0..<emptyStars {
            starStackView.addArrangedSubview(createStarImage(isFilled: false))
        }

        addressLabel.text = toilet.address

        if let userRating = toilet.userRating {
            myRatingLabel.text = "My Rating: \(userRating)"
        } else {
            myRatingLabel.text = "My Rating: Not Rated"
        }
    }

    private func createStarImage(isFilled: Bool = false, isHalf: Bool = false) -> UIImageView {
        let imageView = UIImageView()
        let imageName: String
        if isHalf {
            imageName = "star.leadinghalf.filled" // Half-filled star (SF Symbol)
        } else {
            imageName = isFilled ? "star.fill" : "star"
        }
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = isFilled || isHalf ? .systemYellow : .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }

    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
