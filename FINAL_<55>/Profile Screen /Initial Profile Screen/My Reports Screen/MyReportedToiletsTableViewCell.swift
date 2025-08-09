//
//  MyReportedToiletsTableViewCell.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.



import UIKit

class MyReportedToiletsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyReportedToiletsTableViewCell"

    // MARK: - UI Components
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let reasonLabel = UILabel()
    private let statusLabel = UILabel()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Light background
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Container view styling
        containerView.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0) // Softer white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Name label styling
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        nameLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Dark gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Status label styling
        statusLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        statusLabel.textColor = .white
        statusLabel.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0) // Green by default
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        statusLabel.layer.shadowOpacity = 0.2
        statusLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        statusLabel.layer.shadowRadius = 2
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusLabel)

        // Reason label styling
        reasonLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        reasonLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Softer gray
        reasonLabel.numberOfLines = 0
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(reasonLabel)
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

            // Status label constraints
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),

            // Reason label constraints
            reasonLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            reasonLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            reasonLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            reasonLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configure Cell
    func configure(with reportedToilet: ReportedToilet) {
        nameLabel.text = reportedToilet.name
        reasonLabel.text = "Reason: \(reportedToilet.reportReason)"

        switch reportedToilet.status {
        case .underReview:
            statusLabel.text = "Under Review"
            statusLabel.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0) // Green
        case .deleted:
            statusLabel.text = "Deleted"
            statusLabel.backgroundColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0) // Red
        case .unknown:
            statusLabel.text = "Unknown Status"
            statusLabel.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Gray
        }
    }
}

