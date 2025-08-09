//
//  MyRatingsViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/30/24.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import MapKit


class MyRatingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    private var myRatingsView: MyRatingsScreenView!
    var toilets: [Toilet] = [] // Replace with your model data
    //weak var delegateToMapView: ViewController!
    
    // MARK: - Lifecycle
    override func loadView() {
        myRatingsView = MyRatingsScreenView()
        view = myRatingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Ratings"
        setupTableView()
        fetchToilets()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        myRatingsView.tableView.delegate = self
        myRatingsView.tableView.dataSource = self
    }
    
    
    private func fetchToilets() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        toilets = [] // Clear array to avoid duplication

        let db = Firestore.firestore()
        let reviewedToiletsRef = db
            .collection("users")
            .document(user.uid)
            .collection("reviewedToilets")

        reviewedToiletsRef.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching reviewed toilets: \(error)")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No reviewed toilets found for user: \(user.uid)")
                return
            }

            print("Fetched \(documents.count) reviewed toilets")

            let group = DispatchGroup()

            for document in documents {
                let toiletID = document.documentID // Use the document ID as the toilet ID
                print("Using document ID as toilet ID: \(toiletID)")
                let userRating = document.data()["rating"] as? Double // Get the user's rating

                group.enter()
                let toiletRef = db.collection("toilets").document(toiletID)
                toiletRef.getDocument { toiletSnapshot, error in
                    defer { group.leave() }

                    if let error = error {
                        print("Error fetching toilet details for ID \(toiletID): \(error)")
                        return
                    }

                    guard let toiletData = toiletSnapshot?.data() else {
                        print("Error: Toilet document not found for ID \(toiletID)")
                        return
                    }

                    print("Fetched toilet data: \(toiletData)")

                    do {
                        if var toilet = try toiletSnapshot?.data(as: Toilet.self) {
                            toilet.userRating = userRating // Add the user's rating
                            self.toilets.append(toilet)
                            print("Added toilet to list: \(toilet.name)")
                        }
                    } catch {
                        print("Error decoding toilet data for ID \(toiletID): \(error)")
                    }
                }
            }

            group.notify(queue: .main) {
                print("Finished fetching toilets. Reloading table view with \(self.toilets.count) toilets")
                self.myRatingsView.tableView.reloadData()
            }
        }
    }


    
    
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toilets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRatingsTableViewCell.reuseIdentifier, for: indexPath) as? MyRatingsTableViewCell else {
            return UITableViewCell()
        }
        let toilet = toilets[indexPath.row]
        cell.configure(with: toilet)
        return cell
    }
 
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToilet = toilets[indexPath.row]

        // Post a notification with the selected toilet's data
        NotificationCenter.default.post(
            name: Notification.Name("ToiletSelected"),
            object: nil,
            userInfo: [
                "latitude": selectedToilet.location.latitude,
                "longitude": selectedToilet.location.longitude,
                "name": selectedToilet.name
            ]
        )

        // Dismiss both the My Ratings screen and the Profile screen
         if let rootPresenter = presentingViewController?.presentingViewController {
             rootPresenter.dismiss(animated: true) {
                 print("Dismissed both MyRatingsViewController and ProfileViewController")
             }
         } else {
             dismiss(animated: true) {
                 print("Dismissed only MyRatingsViewController")
             }
         }
    }

}

