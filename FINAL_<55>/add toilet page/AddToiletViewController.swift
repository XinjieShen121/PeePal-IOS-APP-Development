//
//  AddToiletViewController.swift
//  FINAL_<55>
//
//  Created by Yongru Wang on 11/28/24.
//

import UIKit
import Firebase

protocol AddToiletViewControllerDelegate: AnyObject {
    func didAddToilet()
}

class AddToiletViewController: UIViewController {
    let addToiletView = AddToiletView()
    let db = Firestore.firestore()
    weak var delegate: AddToiletViewControllerDelegate?
    
    override func loadView() {
        view = addToiletView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthenticationStatus()
        setupNavigationBar()
        setupActions()
    }
    
    // adding feature restricted to logged in users
    func checkAuthenticationStatus() {
        if Auth.auth().currentUser == nil {
            presentAlert(title: "Not Logged In", message: "You must be logged in to add a toilet.") {
                self.dismiss(animated: true)
            }
        }
    }

    func setupNavigationBar() {
        title = "Add a Toilet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(dismissViewController)
        )
    }

    func setupActions() {
        addToiletView.addButton.addTarget(self, action: #selector(onAddToiletTapped), for: .touchUpInside)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }

    @objc func onAddToiletTapped() {
        guard let currentUser = Auth.auth().currentUser else {
            presentAlert(title: "Not Logged In", message: "You must be logged in to add a toilet.")
            return
        }

        // Validate input
        guard
            let name = addToiletView.nameTextField.text, !name.isEmpty,
            let address = addToiletView.addressTextField.text, !address.isEmpty,
            let latitudeText = addToiletView.latitudeTextField.text,
            let longitudeText = addToiletView.longitudeTextField.text,
            let latitude = Double(latitudeText), latitude >= -90, latitude <= 90,
            let longitude = Double(longitudeText), longitude >= -180, longitude <= 180
        else {
            presentAlert(title: "Error", message: "Please fill in all fields correctly.")
            return
        }
        
        // Default opening hours
        let openingHours = addToiletView.openingHoursTextField.text?.isEmpty == false
            ? addToiletView.openingHoursTextField.text!
            : "Unknown Hours"

        var selectedTypes = addToiletView.typeCheckboxes
            .filter { $0.isSelected }
            .map { $0.title(for: .normal) ?? "" }
        if selectedTypes.isEmpty {
            selectedTypes.append("Public")
        }

        let toilet = Toilet(
            id: nil,
            name: name,
            address: address,
            location: GeoPoint(latitude: latitude, longitude: longitude),
            openingHours: openingHours,
            type: selectedTypes,
            rating: 0.0,
            reviews: []
        )

        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()

        // Firestore batch operation
        let batch = db.batch()

        // Add to `toilets` collection
        let toiletsRef = db.collection("toilets").document() // Generate unique document ID
        batch.setData([
            "name": name,
            "address": address,
            "location": GeoPoint(latitude: latitude, longitude: longitude),
            "openingHours": openingHours,
            "type": selectedTypes,
            "rating": 0.0,
            "reviews": []
        ], forDocument: toiletsRef)

        // Add to user's `addedToilets` subcollection
        let userToiletRef = db
            .collection("users")
            .document(currentUser.uid) // Use the unwrapped currentUser
            .collection("addedToilets")
            .document(toiletsRef.documentID)

        batch.setData([
            "name": name,
            "address": address,
            "location": GeoPoint(latitude: latitude, longitude: longitude),
            "openingHours": openingHours,
            "type": selectedTypes,
            "rating": 0.0
        ], forDocument: userToiletRef)

        // Commit the batch
        batch.commit { [weak self] error in
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()

                if let error = error {
                    print("Error adding toilet: \(error.localizedDescription)")
                    self?.presentAlert(title: "Error", message: "Failed to add toilet. Please try again.")
                } else {
                    self?.presentAlert(title: "Success", message: "Toilet added successfully!") {
                        self?.delegate?.didAddToilet()
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }

    
    func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

}
