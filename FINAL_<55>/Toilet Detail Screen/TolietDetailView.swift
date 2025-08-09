//
//  TolietDetailView.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/26/24.
//


import UIKit

class ToiletDetailView: UIView {
    var labelName: UILabel!
    var labelAddress: UILabel!
    var labelOpeningHours: UILabel!
    var iconsStackView: UIStackView!
    var rateTitleLabel: UILabel!
    var ratePlaceholderView: UIView!
    var warningLabel: UILabel! // Warning for reports
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Light yellow
        setupNameLabel()
        setupAddressLabel()
        setupOpeningHoursLabel()
        setupIconsStackView()
        setupRateSection()
        setupWarningLabel()
        initConstraints()
    }
    
    func setupNameLabel() {
        labelName = UILabel()
        labelName.font = UIFont(name: "AvenirNext-Bold", size: 24)
        labelName.numberOfLines = 0
        labelName.textColor = UIColor.darkGray
        labelName.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelName)
    }
    
    func setupAddressLabel() {
        labelAddress = UILabel()
        labelAddress.font = UIFont(name: "AvenirNext-Regular", size: 16)
        labelAddress.numberOfLines = 0
        labelAddress.textColor = UIColor.gray
        labelAddress.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelAddress)
    }
    
    func setupOpeningHoursLabel() {
        labelOpeningHours = UILabel()
        labelOpeningHours.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        labelOpeningHours.textColor = UIColor(red: 0.1, green: 0.4, blue: 0.7, alpha: 1.0) // Blue
        labelOpeningHours.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelOpeningHours)
    }
    
    func setupIconsStackView() {
        iconsStackView = UIStackView()
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = 8
        iconsStackView.alignment = .center
        iconsStackView.distribution = .fillEqually
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconsStackView)
    }
    
    func setupRateSection() {
        rateTitleLabel = UILabel()
        rateTitleLabel.text = "Rate"
        rateTitleLabel.font = UIFont(name: "AvenirNext-Bold", size: 18)
        rateTitleLabel.textColor = UIColor.darkGray
        rateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rateTitleLabel)
        
        ratePlaceholderView = UIView()
        ratePlaceholderView.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0) // Light cream
        ratePlaceholderView.layer.cornerRadius = 8
        ratePlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratePlaceholderView)
    }
    
    func setupWarningLabel() {
        warningLabel = UILabel()
        warningLabel.text = ""
        warningLabel.textColor = UIColor.red
        warningLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        warningLabel.numberOfLines = 0
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(warningLabel)
    }
    
    func showWarning(_ message: String) {
        warningLabel.text = message
        warningLabel.isHidden = false
    }
    
    func configureView(toilet: Toilet) {
        labelName.text = toilet.name
        labelAddress.text = toilet.address
        labelOpeningHours.text = toilet.openingHours

        if let reviews = toilet.reviews, !reviews.isEmpty {
            rateTitleLabel.text = "Rating: \(String(format: "%.1f", toilet.rating))"
        } else {
            rateTitleLabel.text = "No Reviews"
        }

        iconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in toilet.type {
            if let image = UIImage(named: ToiletIconUtils.iconName(for: type)) {
                let icon = UIImageView(image: image)
                icon.contentMode = .scaleAspectFit
                icon.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    icon.widthAnchor.constraint(equalToConstant: 32),
                    icon.heightAnchor.constraint(equalToConstant: 32)
                ])
                iconsStackView.addArrangedSubview(icon)
            }
        }
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            labelAddress.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelAddress.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelAddress.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            
            labelOpeningHours.topAnchor.constraint(equalTo: labelAddress.bottomAnchor, constant: 16),
            labelOpeningHours.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            iconsStackView.topAnchor.constraint(equalTo: labelOpeningHours.bottomAnchor, constant: 16),
            iconsStackView.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            rateTitleLabel.topAnchor.constraint(equalTo: iconsStackView.bottomAnchor, constant: 24),
            rateTitleLabel.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            warningLabel.topAnchor.constraint(equalTo: rateTitleLabel.bottomAnchor, constant: 16),
            warningLabel.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            ratePlaceholderView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 8),
            ratePlaceholderView.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            ratePlaceholderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ratePlaceholderView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
