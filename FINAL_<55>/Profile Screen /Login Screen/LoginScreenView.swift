//
//  LoginScreenView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import UIKit

class LoginScreenView: UIView {

    // MARK: - UI Components
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var logoImageView: UIImageView! // Added for the logo
    var inputContainer: UIView! // Added container for email and password fields
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // Set background color HEX: #ffe49b
        
        setupLogoImageView() // Added setup for logo
        setupInputContainer() // Added container setup
        setupLoginButton()
        initConstraints()
    }
    
    // MARK: - Setup Functions
    func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo") // Use the name of the image in Assets
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView) // Add to the view hierarchy
    }
    
    func setupInputContainer() {
           inputContainer = UIView()
           inputContainer.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Same as app background
           inputContainer.layer.cornerRadius = 20
//           inputContainer.layer.borderWidth = 1
//           inputContainer.layer.borderColor = UIColor.lightGray.cgColor
           inputContainer.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(inputContainer)
           
        // Email Label
            emailLabel = UILabel()
            emailLabel.text = "Email"
            emailLabel.font = UIFont.boldSystemFont(ofSize: 18)
            emailLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) // RGBA(0, 0, 0, 255)
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(emailLabel)

        // Email Text Field
            emailTextField = UITextField()
            emailTextField.placeholder = "Enter your email"
            emailTextField.borderStyle = .none
            emailTextField.layer.cornerRadius = 10
            emailTextField.autocapitalizationType = .none
            emailTextField.backgroundColor = .white
            emailTextField.keyboardType = .emailAddress
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(emailTextField)

            // Password Label
            passwordLabel = UILabel()
            passwordLabel.text = "Password"
            passwordLabel.font = UIFont.boldSystemFont(ofSize: 18)
            passwordLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) // RGBA(0, 0, 0, 255)
            passwordLabel.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(passwordLabel)

            // Password Text Field
            passwordTextField = UITextField()
            passwordTextField.placeholder = "Enter your password"
            passwordTextField.borderStyle = .none
            passwordTextField.layer.cornerRadius = 10
            passwordTextField.backgroundColor = .white
            passwordTextField.isSecureTextEntry = true
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview(passwordTextField)
       }
    
        
    func setupLoginButton() {
            loginButton = UIButton(type: .system)
            loginButton.setTitle("Login", for: .normal)
            loginButton.backgroundColor = .white
            loginButton.tintColor = .black // Black text
            loginButton.layer.cornerRadius = 15
//            loginButton.layer.borderWidth = 1
//            loginButton.layer.borderColor = UIColor.lightGray.cgColor
            loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(loginButton)
        }

    // MARK: - Constraints Setup
    func initConstraints() {
        NSLayoutConstraint.activate([
                    // Logo Image View constraints
                    logoImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
                    logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    logoImageView.widthAnchor.constraint(equalToConstant: 150),
                    logoImageView.heightAnchor.constraint(equalToConstant: 150),

                    // Input Container constraints
                    inputContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
                    inputContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
                    inputContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
                    inputContainer.heightAnchor.constraint(equalToConstant: 180), // Adjusted for spacing

                    // Email Label constraints
                    emailLabel.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 10),
                    emailLabel.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),

                    // Email Text Field constraints
                    emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
                    emailTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
                    emailTextField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
                    emailTextField.heightAnchor.constraint(equalToConstant: 40),

                    // Password Label constraints
                    passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
                    passwordLabel.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),

                    // Password Text Field constraints
                    passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
                    passwordTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
                    passwordTextField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
                    passwordTextField.heightAnchor.constraint(equalToConstant: 40),

                    // Login Button constraints
                    loginButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 45),
                    loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    loginButton.widthAnchor.constraint(equalToConstant: 120),
                    loginButton.heightAnchor.constraint(equalToConstant: 40)
                ])
    }
    
    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

