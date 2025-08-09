//
//  AddToiletView.swift
//  FINAL_<55>
//
//  Created by Yongru Wang on 11/28/24.
//
//



import UIKit

class AddToiletView: UIView {
    // MARK: - Properties
    var nameTextField: UITextField!
    var addressTextField: UITextField!
    var latitudeTextField: UITextField!
    var longitudeTextField: UITextField!
    var openingHoursTextField: UITextField!
    var typeCheckboxes: [UIButton] = []
    var addButton: UIButton!
    
    let typeOptions = ["Public", "Accessible", "Tampon", "Password"]
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // HEX: #ffe49b
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupTextFields()
        setupCheckboxes()
        setupAddButton()
    }
    
    private func setupTextFields() {
        nameTextField = createTextField(placeholder: "Toilet Name")
        addressTextField = createTextField(placeholder: "Address")
        latitudeTextField = createTextField(placeholder: "Latitude")
        longitudeTextField = createTextField(placeholder: "Longitude")
        openingHoursTextField = createTextField(placeholder: "Opening Hours (e.g., 9:00 AM - 5:00 PM)")
        
        latitudeTextField.keyboardType = .decimalPad
        longitudeTextField.keyboardType = .decimalPad
        
        [nameTextField, addressTextField, latitudeTextField,
         longitudeTextField, openingHoursTextField].forEach { addSubview($0) }
    }
    
    private func setupCheckboxes() {
        for type in typeOptions {
            let button = createCheckboxButton(title: type)
            typeCheckboxes.append(button)
            addSubview(button)
        }
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .system)
        addButton.setTitle("Add Toilet", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18)
        addButton.backgroundColor = UIColor.white
        addButton.tintColor = UIColor.black
        addButton.layer.cornerRadius = 15
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
    }
    
    // MARK: - Helper Methods
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func createCheckboxButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.white
        
        // Use ToiletIconUtils to load png name
        let iconName = ToiletIconUtils.iconName(for: title)
        if let iconImage = UIImage(named: iconName) {
            button.setImage(iconImage, for: .normal)
            print("Successfully loaded icon: \(iconName) for type: \(title)")
        } else {
            print("Failed to load icon: \(iconName) for type: \(title)")
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(typeCheckboxTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func typeCheckboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.blue.cgColor
        } else {
            sender.backgroundColor = .white
            sender.layer.borderWidth = 0
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        setupTextFieldConstraints()
        setupCheckboxConstraints()
        setupAddButtonConstraints()
    }
    
    private func setupTextFieldConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            latitudeTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            latitudeTextField.leadingAnchor.constraint(equalTo: addressTextField.leadingAnchor),
            latitudeTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            longitudeTextField.topAnchor.constraint(equalTo: latitudeTextField.topAnchor),
            longitudeTextField.trailingAnchor.constraint(equalTo: addressTextField.trailingAnchor),
            longitudeTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            openingHoursTextField.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 16),
            openingHoursTextField.leadingAnchor.constraint(equalTo: addressTextField.leadingAnchor),
            openingHoursTextField.trailingAnchor.constraint(equalTo: addressTextField.trailingAnchor)
        ])
    }
    
    private func setupCheckboxConstraints() {
        for (index, button) in typeCheckboxes.enumerated() {
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: addressTextField.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: addressTextField.trailingAnchor),
                button.topAnchor.constraint(equalTo: index == 0
                                         ? openingHoursTextField.bottomAnchor
                                         : typeCheckboxes[index - 1].bottomAnchor,
                                         constant: 12),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func setupAddButtonConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: typeCheckboxes.last!.bottomAnchor, constant: 32),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
