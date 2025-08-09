//
//  MyAddedToiletsViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class MyAddedToiletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    private var myAddedToiletsView: MyAddedToiletsScreenView!
    var toilets: [Toilet] = [] // List of added toilets

    // MARK: - Lifecycle
    override func loadView() {
        myAddedToiletsView = MyAddedToiletsScreenView()
        view = myAddedToiletsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Added Toilets"
        setupTableView()
        fetchToilets()
    }

    // MARK: - Setup Table View
    private func setupTableView() {
        myAddedToiletsView.tableView.delegate = self
        myAddedToiletsView.tableView.dataSource = self
    }

    // MARK: - Fetch Data
    private func fetchToilets() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        toilets = [] // Clear previous data

        let db = Firestore.firestore()
        let addedToiletsRef = db
            .collection("users")
            .document(user.uid)
            .collection("addedToilets")

        addedToiletsRef.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching added toilets: \(error)")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No added toilets found for user: \(user.uid)")
                return
            }

            print("Fetched \(documents.count) added toilets")

            for document in documents {
                do {
                    let toilet = try document.data(as: Toilet.self)
                    self.toilets.append(toilet)
                } catch {
                    print("Error decoding added toilet data: \(error)")
                }
            }

            DispatchQueue.main.async {
                self.myAddedToiletsView.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toilets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAddedToiletsTableViewCell.reuseIdentifier, for: indexPath) as? MyAddedToiletsTableViewCell else {
            return UITableViewCell()
        }
        let toilet = toilets[indexPath.row]
        cell.configure(with: toilet)
        return cell
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToilet = toilets[indexPath.row]

        // Post notification to update main map
        NotificationCenter.default.post(
            name: Notification.Name("ToiletSelected"),
            object: nil,
            userInfo: [
                "latitude": selectedToilet.location.latitude,
                "longitude": selectedToilet.location.longitude,
                "name": selectedToilet.name
            ]
        )

        // Dismiss both the current screen and the Profile screen
        if let rootPresenter = presentingViewController?.presentingViewController {
            rootPresenter.dismiss(animated: true) {
                print("Dismissed both MyAddedToiletsViewController and ProfileViewController")
            }
        } else {
            dismiss(animated: true) {
                print("Dismissed only MyAddedToiletsViewController")
            }
        }
    }
}

