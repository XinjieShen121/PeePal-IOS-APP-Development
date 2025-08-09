//
//  RegisterScreenView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import UIKit

class RegisterScreenView: UIView {
    
    // MARK: - UI Components
    var logoImageView: UIImageView!
    var inputContainer: UIView!
    var labelName: UILabel!
    var textFieldName: UITextField!
    var labelEmail: UILabel!
    var textFieldEmail: UITextField!
    var labelPassword: UILabel!
    var textFieldPassword: UITextField!
    var buttonRegister: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // Set background color HEX: #ffe49b

        
        setupLogoImageView()
        setupInputContainer()
        setupRegisterButton()
        
        initConstraints()
    }
    
    // MARK: - Setup Functions
    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo") // Use the name of the logo in Assets
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }
    
    func setupInputContainer() {
            inputContainer = UIView()
            inputContainer.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Same as app background
            inputContainer.layer.cornerRadius = 20 // Rounded corners
            inputContainer.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(inputContainer)

            // Name Label
            labelName = UILabel()
            labelName.text = "Name"
            labelName.font = UIFont.boldSystemFont(ofSize: 16)
            labelName.textColor = .black
            labelName.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(labelName)

            // Name Text Field
            textFieldName = UITextField()
            textFieldName.placeholder = "Enter your name"
            textFieldName.borderStyle = .none // Remove default border
            textFieldName.backgroundColor = .white // Background color
            textFieldName.layer.cornerRadius = 15 // Rounded corners
            textFieldName.clipsToBounds = true // Ensure rounding is applied
            textFieldName.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(textFieldName)

            // Email Label
            labelEmail = UILabel()
            labelEmail.text = "Email"
            labelEmail.font = UIFont.boldSystemFont(ofSize: 16)
            labelEmail.textColor = .black
            labelEmail.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(labelEmail)

            // Email Text Field
            textFieldEmail = UITextField()
            textFieldEmail.placeholder = "Enter your email"
            textFieldEmail.borderStyle = .none // Remove default border
            textFieldEmail.backgroundColor = .white // Background color
            textFieldEmail.layer.cornerRadius = 15 // Rounded corners
            textFieldEmail.clipsToBounds = true // Ensure rounding is applied
            textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(textFieldEmail)

            // Password Label
            labelPassword = UILabel()
            labelPassword.text = "Password"
            labelPassword.font = UIFont.boldSystemFont(ofSize: 16)
            labelPassword.textColor = .black
            labelPassword.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(labelPassword)

            // Password Text Field
            textFieldPassword = UITextField()
            textFieldPassword.placeholder = "Enter your password"
            textFieldPassword.textContentType = .password
            textFieldPassword.isSecureTextEntry = true // Enable secure text entry
            textFieldPassword.borderStyle = .none // Remove default border
            textFieldPassword.backgroundColor = .white // Background color
            textFieldPassword.layer.cornerRadius = 15 // Rounded corners
            textFieldPassword.clipsToBounds = true // Ensure rounding is applied
            textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(textFieldPassword)
        }

    
    func setupRegisterButton() {
            buttonRegister = UIButton(type: .system)
            buttonRegister.setTitle("Register", for: .normal)
            buttonRegister.backgroundColor = .white
            buttonRegister.tintColor = .black // Black text
            buttonRegister.layer.cornerRadius = 20
            buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 16)
            buttonRegister.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonRegister)
        }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
                    // Logo Image View constraints
                    logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
                    logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    logoImageView.widthAnchor.constraint(equalToConstant: 150),
                    logoImageView.heightAnchor.constraint(equalToConstant: 150),

                    // Input Container constraints
                    inputContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
                    inputContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
                    inputContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
                    inputContainer.heightAnchor.constraint(equalToConstant: 260),

                    // Name Label constraints
                    labelName.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 20),
                    labelName.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),

                    // Name Text Field constraints
                    textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
                    textFieldName.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
                    textFieldName.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
                    textFieldName.heightAnchor.constraint(equalToConstant: 40),

                    // Email Label constraints
                    labelEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 15),
                    labelEmail.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),

                    // Email Text Field constraints
                    textFieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 5),
                    textFieldEmail.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
                    textFieldEmail.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
                    textFieldEmail.heightAnchor.constraint(equalToConstant: 40),

                    // Password Label constraints
                    labelPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 15),
                    labelPassword.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),

                    // Password Text Field constraints
                    textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 5),
                    textFieldPassword.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
                    textFieldPassword.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
                    textFieldPassword.heightAnchor.constraint(equalToConstant: 40),

                    // Register Button constraints
                    buttonRegister.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 30),
                    buttonRegister.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    buttonRegister.widthAnchor.constraint(equalToConstant: 150),
                    buttonRegister.heightAnchor.constraint(equalToConstant: 40)
                ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
