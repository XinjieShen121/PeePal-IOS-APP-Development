//
//  RegisterFirebaseManager.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/21/24.
//

import Foundation
import FirebaseAuth
//import FirebaseStorage
import FirebaseFirestore

extension SignUpViewController{
    
    func registerNewAccount(){
        
        //MARK: display the progress indicator...
        showActivityIndicator()
        
        // Get input from text fields
        guard let name = registerView.textFieldName.text, !name.isEmpty,
              let email = registerView.textFieldEmail.text, !email.isEmpty,
              let password = registerView.textFieldPassword.text, !password.isEmpty else {
            // Hide activity indicator
            hideActivityIndicator()
            // Show alert if any field is empty
            showAlert(title: "Error", message: "All fields are required. Please fill in your name, email, and password.")
            return
        }
        
        // Validate email format
        guard isValidEmail(email) else {
            hideActivityIndicator()
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        // Create a Firebase user with email and password
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            // User creation successful
            self.setNameOfTheUserInFirebaseAuth(name: name, email: email)
        }
    }
    
    // Helper function to validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true)
    }
    
    func setNameOfTheUserInFirebaseAuth(name: String, email: String) {
        // Update the display name in Firebase Auth
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                // Handle error updating the profile
                print("Error occurred while updating profile: \(error.localizedDescription)")
            } else {
                // Successfully updated the profile
                print("Profile updated successfully.")
                
                // Save user data to Firestore
                if let userID = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(userID).setData([
                        "name": name,
                        "email": email
                    ]) { error in
                        if let error = error {
                            // Handle error saving user data to Firestore
                            print("Error occurred while saving user data: \(error.localizedDescription)")
                        } else {
                            print("User data saved successfully in Firestore.")
                            
                            // Hide the activity indicator
                            self.hideActivityIndicator()
                            
                            // Show success message and dismiss registration page
                            self.showAlert(
                                title: "Registration Successful",
                                message: "Your account has been created successfully!",
                                completion: { [weak self] _ in
                                    self?.dismiss(animated: true) {
                                        // update logged in profile page
                                        NotificationCenter.default.post(
                                            name: Notification.Name("UserDidLogin"),
                                            object: nil
                                        )
                                    }
                                }
                            )
                        }
                    }
                }
            }
        })
    }
}

