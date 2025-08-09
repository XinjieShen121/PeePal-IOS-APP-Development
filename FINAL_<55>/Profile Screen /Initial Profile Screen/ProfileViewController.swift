//
//  ProfileViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    // MARK: - Properties
    private var profileView: ProfileScreenView!
    
    // MARK: - Lifecycle
    override func loadView() {
        profileView = ProfileScreenView()
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        setupActions()
        setupNotifications()
        updateUIForAuthState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForAuthState()
    }
    
    // MARK: - Setup
    private func setupActions() {
        // Existing actions
        profileView.loginButton.addTarget(self, action: #selector(onLoginPressed), for: .touchUpInside)
        profileView.signUpButton.addTarget(self, action: #selector(onSignUpPressed), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(onLogoutPressed), for: .touchUpInside)
        
        // New button actions
        profileView.myRatingsButton.addTarget(self, action: #selector(onMyRatingsPressed), for: .touchUpInside)
        profileView.myAddedToiletsButton.addTarget(self, action: #selector(onMyAddedToiletsPressed), for: .touchUpInside)
        profileView.myReportsButton.addTarget(self, action: #selector(onMyReportsPressed), for: .touchUpInside)
    }
    
    // MARK: - UI Updates
    private func updateUIForAuthState() {
        if let user = Auth.auth().currentUser {
            profileView.updateUIForAuthState(
                isLoggedIn: true,
                userName: user.displayName,
                email: user.email
            )
        } else {
            profileView.updateUIForAuthState(isLoggedIn: false)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDidLogin),
            name: Notification.Name("UserDidLogin"),
            object: nil
        )
    }
    
    @objc private func userDidLogin() {
        updateUIForAuthState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    @objc func onLoginPressed() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true)
    }
    
    @objc func onSignUpPressed() {
        let signUpVC = SignUpViewController()
        let navController = UINavigationController(rootViewController: signUpVC)
        present(navController, animated: true)
    }
    
    @objc func onLogoutPressed() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                self?.updateUIForAuthState()
                
                // Post notification to refresh annotations
                NotificationCenter.default.post(name: Notification.Name("UserLoggedOut"), object: nil)
            } catch {
                print("Error signing out: \(error)")
                self?.showAlert(message: "Failed to logout. Please try again.")
            }
        })
        
        present(alert, animated: true)
    }

    
    @objc func onMyRatingsPressed() {
        let myRatingsVC = MyRatingsViewController()
        //myRatingsVC.delegateToMapView = delegateToMapView // Pass the map view controller if needed
        let navController = UINavigationController(rootViewController: myRatingsVC)
        present(navController, animated: true)
    }

    @objc func onMyAddedToiletsPressed() {
        let myAddedToiletsVC = MyAddedToiletsViewController()
        let navController = UINavigationController(rootViewController: myAddedToiletsVC)
        present(navController, animated: true)
    }

    
    @objc func onMyReportsPressed() {
        let myReportedToiletsVC = MyReportedToiletsViewController()
        let navController = UINavigationController(rootViewController: myReportedToiletsVC)
        present(navController, animated: true)
    }

    
    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
