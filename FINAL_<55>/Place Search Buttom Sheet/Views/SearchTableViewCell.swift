//
//  SearchTableViewCell.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var labelTitle: UILabel!
    var labelAddress: UILabel!
    var iconsStackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupAddressLabel()
        setupIconsStackView()
        initConstraints()
    }
    
    func setupTitleLabel() {
        labelTitle = UILabel()
        labelTitle.font = UIFont(name: "AvenirNext-Bold", size: 15) // Updated font style and size
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
    }
    
    func setupAddressLabel() {
        labelAddress = UILabel()
        labelAddress.font = UIFont(name: "AvenirNext-Regular", size: 13) // Updated font style and size
        labelAddress.textColor = .gray
        labelAddress.numberOfLines = 0 // Allow multiple lines for better layout
        labelAddress.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelAddress)
    }
    
    func setupIconsStackView() {
        iconsStackView = UIStackView()
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = 8
        iconsStackView.alignment = .center
        iconsStackView.distribution = .fillEqually
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconsStackView)
    }
    
    func configureCell(toilet: Toilet) {
        labelTitle.text = toilet.name
        labelAddress.text = toilet.address
        
        iconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        print("Toilet \(toilet.name) has \(toilet.type.count) types")
        
        for (index, type) in toilet.type.enumerated() {
            if index >= 2 { break }
            if let image = UIImage(named: ToiletIconUtils.iconName(for: type)) {
                let icon = UIImageView(image: image)
                icon.contentMode = .scaleAspectFit
                icon.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    icon.widthAnchor.constraint(equalToConstant: 24),
                    icon.heightAnchor.constraint(equalToConstant: 24)
                ])
                
                iconsStackView.addArrangedSubview(icon)
                print("Added icon for type: \(type)")
            } else {
                print("Failed to load icon for type: \(type)")
            }
        }
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12), // Increased top spacing
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(lessThanOrEqualTo: iconsStackView.leadingAnchor, constant: -8),
            
            labelAddress.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8), // Increased spacing between labels
            labelAddress.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelAddress.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            
            iconsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentView.bottomAnchor.constraint(equalTo: labelAddress.bottomAnchor, constant: 12) // Added bottom padding
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
