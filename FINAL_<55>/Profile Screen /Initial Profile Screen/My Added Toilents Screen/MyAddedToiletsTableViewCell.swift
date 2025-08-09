//
//  MyAddedToiletsTableViewCell.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.
//

import UIKit
import MapKit

class MyAddedToiletsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyAddedToiletsTableViewCell"

    // MARK: - UI Components
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let previewMapView = MKMapView() // Map view preview

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
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 20) // Modern font
        nameLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Dark gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Address label styling
        addressLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        addressLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Softer gray
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addressLabel)

        // Map view styling
        previewMapView.layer.cornerRadius = 8
        previewMapView.layer.masksToBounds = true
        previewMapView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(previewMapView)
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

            // Address label constraints
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Map view constraints
            previewMapView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            previewMapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            previewMapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            previewMapView.heightAnchor.constraint(equalToConstant: 150), // Map height
            previewMapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configure Cell
    func configure(with toilet: Toilet) {
        nameLabel.text = toilet.name
        addressLabel.text = toilet.address

        // Configure the map preview
        let coordinate = CLLocationCoordinate2D(latitude: toilet.location.latitude, longitude: toilet.location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        previewMapView.setRegion(region, animated: false)

        // Add annotation
        previewMapView.removeAnnotations(previewMapView.annotations) // Clear previous annotations
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = toilet.name
        previewMapView.addAnnotation(annotation)
    }
}

