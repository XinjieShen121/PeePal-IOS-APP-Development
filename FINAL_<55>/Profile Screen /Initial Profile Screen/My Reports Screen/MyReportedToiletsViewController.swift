//
//  MyReportedToiletsViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyReportedToiletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    private var myReportedToiletsView: MyReportedToiletsScreenView!
    private var reportedToilets: [ReportedToilet] = [] // Stores reported toilets with status
    private let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func loadView() {
        myReportedToiletsView = MyReportedToiletsScreenView()
        view = myReportedToiletsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Reported Toilets"
        setupTableView()
        setupNavigationBar()
        fetchReportedToilets()
    }

    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(onBackPressed)
        )
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func onBackPressed() {
        dismiss(animated: true) // Dismiss the modal view controller
    }

    // MARK: - Setup Table View
    private func setupTableView() {
        myReportedToiletsView.tableView.delegate = self
        myReportedToiletsView.tableView.dataSource = self
    }

    // MARK: - Fetch Reported Toilets
    private func fetchReportedToilets() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let reportedToiletsRef = db
            .collection("users")
            .document(user.uid)
            .collection("reportedToilets")

        reportedToiletsRef.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching reported toilets: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No reported toilets found")
                return
            }

            self.reportedToilets = documents.map { doc -> ReportedToilet in
                let data = doc.data()
                return ReportedToilet(
                    id: doc.documentID,
                    name: data["toiletName"] as? String ?? "Unknown",
                    reportReason: data["reportReason"] as? String ?? "No reason",
                    status: .unknown // Placeholder until status is determined
                )
            }

            self.determineToiletStatus()
        }
    }

    // MARK: - Determine Toilet Status
    private func determineToiletStatus() {
        let group = DispatchGroup()

        for (index, reportedToilet) in reportedToilets.enumerated() {
            group.enter()

            let toiletRef = db.collection("toilets").document(reportedToilet.id)
            toiletRef.getDocument { [weak self] document, error in
                defer { group.leave() }

                if let document = document, document.exists {
                    self?.reportedToilets[index].status = .underReview
                } else {
                    self?.reportedToilets[index].status = .deleted
                }
            }
        }

        group.notify(queue: .main) {
            self.myReportedToiletsView.tableView.reloadData()
        }
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportedToilets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyReportedToiletsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MyReportedToiletsTableViewCell else {
            return UITableViewCell()
        }
        let reportedToilet = reportedToilets[indexPath.row]
        cell.configure(with: reportedToilet)
        return cell
    }
}

