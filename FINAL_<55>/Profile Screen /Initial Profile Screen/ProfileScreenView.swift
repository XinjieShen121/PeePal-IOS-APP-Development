//
//  ProfileScreenView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/21/24.
//

import UIKit

class ProfileScreenView: UIView {
    // MARK: - UI Components
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var userNameLabel: UILabel!
    var emailLabel: UILabel!
    var welcomeBackLabel: UILabel!
    var myRatingsButton: UIButton!
    var myAddedToiletsButton: UIButton!
    var myReportsButton: UIButton!
    var logoutButton: UIButton!
    var logoImageView: UIImageView!
    var labelContainer: UIView!



    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // HEX: #ffe49b
        setupAllUI()
        initConstraints()
    }

    private func setupAllUI() {
        setupLoginButton()
        setupSignUpButton()
        setupUserInfo()
        setupWelcomeBackLabel()
        setupMyRatingsButton()
        setupMyAddedToiletsButton()
        setupMyReportsButton()
        setupLogoutButton()
        setupLogoImage()
        setupLabelContainer()
    }

    // MARK: - Setup Functions
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.tintColor = .black
        loginButton.layer.cornerRadius = 15
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
    }

    func setupSignUpButton() {
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.tintColor = .black
        signUpButton.layer.cornerRadius = 15
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signUpButton)
    }

    func setupUserInfo() {
        userNameLabel = UILabel()
        userNameLabel.font = .boldSystemFont(ofSize: 24)
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userNameLabel)

        emailLabel = UILabel()
        emailLabel.font = .systemFont(ofSize: 16)
        emailLabel.textColor = .gray
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
    }

    func setupWelcomeBackLabel() {
        welcomeBackLabel = UILabel()
        welcomeBackLabel.font = .boldSystemFont(ofSize: 20)
        welcomeBackLabel.textColor = .darkGray
        welcomeBackLabel.textAlignment = .center
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(welcomeBackLabel)
    }

    func setupMyRatingsButton() {
        myRatingsButton = UIButton(type: .system)
        myRatingsButton.setTitle("My Ratings", for: .normal)
        myRatingsButton.backgroundColor = .white
        myRatingsButton.tintColor = .black
        myRatingsButton.layer.cornerRadius = 15
        myRatingsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        myRatingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myRatingsButton)
    }

    func setupMyAddedToiletsButton() {
        myAddedToiletsButton = UIButton(type: .system)
        myAddedToiletsButton.setTitle("My Added Toilets", for: .normal)
        myAddedToiletsButton.backgroundColor = .white
        myAddedToiletsButton.tintColor = .black
        myAddedToiletsButton.layer.cornerRadius = 15
        myAddedToiletsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        myAddedToiletsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myAddedToiletsButton)
    }

    func setupMyReportsButton() {
        myReportsButton = UIButton(type: .system)
        myReportsButton.setTitle("My Reports", for: .normal)
        myReportsButton.backgroundColor = .white
        myReportsButton.tintColor = .black
        myReportsButton.layer.cornerRadius = 15
        myReportsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        myReportsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myReportsButton)
    }

    func setupLogoutButton() {
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .white
        logoutButton.tintColor = .systemRed
        logoutButton.layer.cornerRadius = 15
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoutButton)
    }
    
    func setupLogoImage() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo") // Replace "logo" with your image asset name
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }
    
    func setupLabelContainer() {
        // Create the container
        labelContainer = UIView()
        labelContainer.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.76, alpha: 1.0) // Light background
        labelContainer.layer.cornerRadius = 20
        labelContainer.layer.shadowColor = UIColor.black.cgColor
        labelContainer.layer.shadowOpacity = 0.1
        labelContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        labelContainer.layer.shadowRadius = 4
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelContainer)
        
        // Add userNameLabel
        userNameLabel = UILabel()
        userNameLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Darker text color
        userNameLabel.text = "Username"
        labelContainer.addSubview(userNameLabel)
        
        // Add emailLabel
        emailLabel = UILabel()
        emailLabel.font = UIFont(name: "AvenirNext-Regular", size: 18) // Slightly smaller, modern font
        emailLabel.textAlignment = .center
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = UIColor.gray // Subtle text for secondary info
        emailLabel.text = "Email"
        labelContainer.addSubview(emailLabel)
        
        // Add welcomeBackLabel
        welcomeBackLabel = UILabel()
        welcomeBackLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 22) // Stronger font for emphasis
        welcomeBackLabel.textAlignment = .center
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeBackLabel.textColor = UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1.0) // Nice blue accent
        welcomeBackLabel.text = "Welcome Back!"
        labelContainer.addSubview(welcomeBackLabel)
        
        // Add constraints for labels inside the container
            NSLayoutConstraint.activate([
                userNameLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: 15),
                userNameLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 10),
                userNameLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -10),

                emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
                emailLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 10),
                emailLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -10),

                welcomeBackLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
                welcomeBackLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: 10),
                welcomeBackLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -10),
                welcomeBackLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -15),
            ])
    }


    // MARK: - Constraints Setup
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Logo constraints
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 150), // Adjust as needed
            logoImageView.heightAnchor.constraint(equalToConstant: 150), // Adjust as needed

               
            // Login/Signup buttons constraints
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            // User info constraints
            // Label container constraints
            labelContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            labelContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            labelContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),

            // My Ratings button constraints
            myRatingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myRatingsButton.topAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: 20),
            myRatingsButton.widthAnchor.constraint(equalToConstant: 200),
            myRatingsButton.heightAnchor.constraint(equalToConstant: 50),
            

            // My Added Toilets button constraints
            myAddedToiletsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myAddedToiletsButton.topAnchor.constraint(equalTo: myRatingsButton.bottomAnchor, constant: 20),
            myAddedToiletsButton.widthAnchor.constraint(equalToConstant: 200),
            myAddedToiletsButton.heightAnchor.constraint(equalToConstant: 50),

            // My Reports button constraints
            myReportsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            myReportsButton.topAnchor.constraint(equalTo: myAddedToiletsButton.bottomAnchor, constant: 20),
            myReportsButton.widthAnchor.constraint(equalToConstant: 200),
            myReportsButton.heightAnchor.constraint(equalToConstant: 50),

            // Logout button constraints
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UI State Update
    func updateUIForAuthState(isLoggedIn: Bool, userName: String? = nil, email: String? = nil) {
        // Toggle visibility of login and sign-up buttons
        loginButton.isHidden = isLoggedIn
        signUpButton.isHidden = isLoggedIn

        // Toggle visibility of the container and its content
        labelContainer.isHidden = !isLoggedIn
        myRatingsButton.isHidden = !isLoggedIn
        myAddedToiletsButton.isHidden = !isLoggedIn
        myReportsButton.isHidden = !isLoggedIn
        logoutButton.isHidden = !isLoggedIn

        if isLoggedIn {
            // Update labels with user information
            welcomeBackLabel.text = "Welcome back, \(userName ?? "User")!"
            userNameLabel.text = userName
            emailLabel.text = email
        } else {
            // Clear labels when logged out
            welcomeBackLabel.text = ""
            userNameLabel.text = ""
            emailLabel.text = ""
        }
    }

    // MARK: - Required Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
