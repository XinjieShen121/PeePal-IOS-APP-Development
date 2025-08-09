//
//  LoginViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/21/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: - Properties
    private var loginScreenView: LoginScreenView!
    private let childProgressView = ProgressSpinnerViewController()
    
    // MARK: - Lifecycle
    override func loadView() {
        loginScreenView = LoginScreenView()
        view = loginScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        // 添加返回按鈕
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupNavigationBar() {
            let closeButton = UIBarButtonItem(
                title: "Close",
                style: .plain,
                target: self,
                action: #selector(closeTapped)
            )
            navigationItem.leftBarButtonItem = closeButton
        }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func setupActions() {
        loginScreenView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func handleLogin() {
        guard let email = loginScreenView.emailTextField.text, !email.isEmpty,
              let password = loginScreenView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        loginScreenView.loginButton.isEnabled = false
        showActivityIndicator()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.loginScreenView.loginButton.isEnabled = true
            
            if let error = error {
                self.showAlert(title: "Login Failed", message: "Invalid email or password. Please try again.")
            } else {
                // 登錄成功，顯示成功提示後關閉登錄頁面
                self.showAlert(
                    title: "Success",
                    message: "Welcome back!",
                    completion: { [weak self] _ in
                        self?.dismiss(animated: true) {
                            // 發送通知以更新 Profile 頁面
                            NotificationCenter.default.post(
                                name: Notification.Name("UserDidLogin"),
                                object: nil
                            )
                        }
                    }
                )
            }
            //self.showActivityIndicator()
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true)
    }
}

// Extension for Progress Spinner
extension LoginViewController: ProgressSpinnerDelegate {
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}

