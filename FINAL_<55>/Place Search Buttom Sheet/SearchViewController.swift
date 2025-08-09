//
//  SearchViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class SearchViewController: UIViewController {
    var delegateToMapView: ViewController!
    var toilets: [Toilet] = []
    let db = Firestore.firestore()
    let searchBottomSheet = SearchBottomSheet()
    
    //MARK: (rating) Picker View Container
    var pickerContainerView: UIView!
    var pickerView: UIPickerView!
    
    //MARK: (report) picker view container
    var reportPickerContainerView: UIView!
    var reportPickerView: UIPickerView!
    
    private var bottomSheetHeightConstraint: NSLayoutConstraint!
    
    // predefined report options
    private let reportOptions = [
        "permanently closed",
        "not a public toilet",
        "opening hours incorrect",
        "other info is incorrect"
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("SearchViewController initialized")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("SearchViewController initialized")
    }
    
    override func loadView() {
        view = searchBottomSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadToilets()
        
        searchBottomSheet.tableViewSearchResults.delegate = self
        searchBottomSheet.tableViewSearchResults.dataSource = self
        
        setupRatingPickerView()
        setupReportPickerView()
        
        setupSearchBottomSheet()
        
        print("SearchViewController: Setting up observer for ToiletsUpdated notification.")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleToiletsUpdated(_:)),
            name: Notification.Name("ToiletsUpdated"),
            object: nil
        )
        
   
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("SearchViewController deallocated")
    }
    
    
    @objc private func handleToiletsUpdated(_ notification: Notification) {
        print("handleToiletsUpdated called")
        guard let userInfo = notification.userInfo,
              let updatedToilets = userInfo["toilets"] as? [Toilet] else {
            return
        }
        print("Received updated toilets: \(updatedToilets.map { $0.name })")
        self.toilets = updatedToilets
        self.searchBottomSheet.tableViewSearchResults.reloadData()
    }
    
    private func setupSearchBottomSheet() {
        // ensure that the container doex not stretch with sliding content
        if let sheet = sheetPresentationController {
               sheet.detents = [.custom { context in
                   return 350
               }]
               sheet.prefersGrabberVisible = true
               sheet.preferredCornerRadius = 12
           }
    }
    
    private func configureTableView() {
        searchBottomSheet.tableViewSearchResults.delegate = self
        searchBottomSheet.tableViewSearchResults.dataSource = self
        searchBottomSheet.tableViewSearchResults.alwaysBounceVertical = true
        searchBottomSheet.tableViewSearchResults.keyboardDismissMode = .onDrag
    }

    // MARK: RATING Picker View
    func setupRatingPickerView() {
        // Container for Picker and Toolbar
        pickerContainerView = UIView()
        pickerContainerView.backgroundColor = .systemBackground
        pickerContainerView.layer.borderWidth = 0.5
        pickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onRatePickerCancel)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onRatePickerDone))
        ]
        
        pickerContainerView.addSubview(toolbar)
        pickerContainerView.addSubview(pickerView)
        view.addSubview(pickerContainerView)
        
        // Layout
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            
            pickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
        
        // Start Hidden
        pickerContainerView.isHidden = true
        pickerContainerView.frame.origin.y = view.frame.height
    }
    
    @objc private func onRatePickerCancel() {
        hideRatePicker()
    }
    
    @objc private func onRatePickerDone() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedRating = ratingOptions[selectedRow].1
        let toilet = toilets[pickerView.tag]
        submitRating(for: toilet, rating: selectedRating)
        hideRatePicker()
        // Show confirmation alert
        showAlert(title: "Rating Submitted", message: "Your rating of \(selectedRating) has been recorded.")
    }
    
    private func hideRatePicker() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.pickerContainerView.isHidden = true
        }
    }
    
    // MARK: REPORT Picker View
    func setupReportPickerView() {
        // Container for Picker and Toolbar
        reportPickerContainerView = UIView()
        reportPickerContainerView.backgroundColor = .systemBackground
        reportPickerContainerView.layer.borderWidth = 0.5
        reportPickerContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        reportPickerView = UIPickerView()
        reportPickerView.delegate = self
        reportPickerView.dataSource = self
        reportPickerView.tag = 999 // Different tag for report picker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onReportPickerCancel)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(onReportPickerDone))
        ]
        
        reportPickerContainerView.addSubview(toolbar)
        reportPickerContainerView.addSubview(reportPickerView)
        view.addSubview(reportPickerContainerView)
        
        // Layout
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        reportPickerView.translatesAutoresizingMaskIntoConstraints = false
        reportPickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reportPickerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportPickerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportPickerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: reportPickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: reportPickerContainerView.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: reportPickerContainerView.topAnchor),
            
            reportPickerView.leadingAnchor.constraint(equalTo: reportPickerContainerView.leadingAnchor),
            reportPickerView.trailingAnchor.constraint(equalTo: reportPickerContainerView.trailingAnchor),
            reportPickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            reportPickerView.bottomAnchor.constraint(equalTo: reportPickerContainerView.bottomAnchor)
        ])
        
        // Start Hidden
        reportPickerContainerView.isHidden = true
        reportPickerContainerView.frame.origin.y = view.frame.height
    }
    
    @objc func onReportPickerCancel() {
        hideReportPicker()
    }

    @objc func onReportPickerDone() {
        let selectedRow = reportPickerView.selectedRow(inComponent: 0)
        let selectedReport = reportOptions[selectedRow]
        let toilet = toilets[reportPickerView.tag]
        submitReport(for: toilet, report: selectedReport)
        hideReportPicker()
        
        // Show confirmation alert
        showAlert(title: "Report Submitted", message: "Your report for '\(selectedReport)' has been recorded.")
    }

    private func hideReportPicker() {
        UIView.animate(withDuration: 0.3) {
            self.reportPickerContainerView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.reportPickerContainerView.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rate = UIContextualAction(style: .normal, title: "Rate") { [weak self] (action, view, completion) in
            self?.presentRatingOptions(for: indexPath)
            completion(true)
        }
        rate.backgroundColor = .systemBlue

        let report = UIContextualAction(style: .normal, title: "Report") { [weak self] (action, view, completion) in
            self?.presentReportOptions(for: indexPath)
            completion(true)
        }
        report.backgroundColor = .systemYellow
        
        let detail = UIContextualAction(style: .normal, title: "Detail"){ [weak self] (action, view, completion) in
            guard let toilet = self?.toilets[indexPath.row] else{
                completion(false)
                return
            }
            self?.navigateToToiletDetail(toilet: toilet)
            completion(true)
        }
        detail.backgroundColor = .systemMint

        let configuration = UISwipeActionsConfiguration(actions: [rate, report, detail])
        return configuration
    }
    
    private func presentRatingOptions(for indexPath: IndexPath) {
        pickerView.tag = indexPath.row // To keep track of the toilet being rated
        pickerContainerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.frame.origin.y = self.view.frame.height - self.pickerContainerView.frame.height
        }
    }
    
    func presentReportOptions(for indexPath: IndexPath) {
        reportPickerView.tag = indexPath.row // Keep track of the toilet being reported
        reportPickerContainerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.reportPickerContainerView.frame.origin.y = self.view.frame.height - self.reportPickerContainerView.frame.height
        }
    }
    
    func navigateToToiletDetail(toilet: Toilet) {
        let detailViewController = ToiletDetailViewController(toilet: toilet)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    private func submitReport(for toilet: Toilet, report: String) {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let userID = user.uid

        let batch = db.batch()

        // Add the report to the `reports` collection
        let reportRef = db.collection("reports").document()
        batch.setData([
            "toiletID": toilet.id ?? "",
            "toiletName": toilet.name,
            "reportReason": report,
            "reportedBy": userID,
            "timestamp": Timestamp(date: Date())
        ], forDocument: reportRef)

        // Update the user's `reportedToilets` subcollection
        let userReportRef = db
            .collection("users")
            .document(userID)
            .collection("reportedToilets")
            .document(toilet.id ?? "")
        batch.setData([
            "toiletName": toilet.name,
            "reportReason": report,
            "timestamp": Timestamp(date: Date())
        ], forDocument: userReportRef)

        // Update the toilet's `reports` array
        let toiletRef = db.collection("toilets").document(toilet.id ?? "")
        let toiletReportData: [String: Any] = [
            "reportedBy": userID,
            "reportReason": report,
            "timestamp": Timestamp(date: Date())
        ]
        batch.updateData([
            "reports": FieldValue.arrayUnion([toiletReportData])
        ], forDocument: toiletRef)

        batch.commit { error in
            if let error = error {
                print("Error submitting report: \(error)")
            } else {
                print("Report submitted successfully for toilet: \(toilet.name)")
            }
        }
    }

    private func submitRating(for toilet: Toilet, rating: Int) {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        let userName = user.displayName ?? "Anonymous"
        let userID = user.uid

        let batch = db.batch()

        // Reference to the toilet's reviews in Firestore
        let toiletRef = db.collection("toilets").document(toilet.id ?? "")
        let userReviewRef = db
            .collection("users")
            .document(userID)
            .collection("reviewedToilets")
            .document(toilet.id ?? "")

        // Check if the user has already rated the toilet
        userReviewRef.getDocument { [weak self] documentSnapshot, error in
            if let error = error {
                print("Error fetching user review: \(error)")
                return
            }

            if let document = documentSnapshot, document.exists {
                // Update the existing rating in the `reviewedToilets`
                batch.updateData([
                    "rating": rating,
                    "toiletName": toilet.name,
                    "address": toilet.address,
                    "latitude": toilet.location.latitude,
                    "longitude": toilet.location.longitude,
                    "type": toilet.type
                ], forDocument: userReviewRef)

                // Update the toilet's review array in the `toilets` collection
                batch.updateData([
                    "reviews": FieldValue.arrayRemove([[
                        "name": userName,
                        "rating": document.data()?["rating"] ?? 0
                    ]])
                ], forDocument: toiletRef)

                batch.updateData([
                    "reviews": FieldValue.arrayUnion([[
                        "name": userName,
                        "rating": rating
                    ]])
                ], forDocument: toiletRef)
            } else {
                // Add a new rating with location data
                let review = [
                    "name": userName,
                    "rating": rating
                ] as [String: Any]
                batch.updateData([
                    "reviews": FieldValue.arrayUnion([review])
                ], forDocument: toiletRef)

                batch.setData([
                    "toiletName": toilet.name,
                    "rating": rating,
                    "address": toilet.address,
                    "latitude": toilet.location.latitude,
                    "longitude": toilet.location.longitude,
                    "type": toilet.type
                ], forDocument: userReviewRef)
            }

            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("Error submitting rating: \(error)")
                } else {
                    print("Rating submitted successfully for toilet: \(toilet.name)")
                    self?.updateToiletAverageRating(toiletID: toilet.id ?? "")
                }
            }
        }
    }


    func updateToiletAverageRating(toiletID: String) {
        let toiletRef = db.collection("toilets").document(toiletID)

        // Fetch toilet data
        toiletRef.getDocument { [weak self] documentSnapshot, error in
            if let error = error {
                print("Error fetching toilet data: \(error)")
                return
            }

            guard let document = documentSnapshot, document.exists else {
                print("Toilet document not found for ID: \(toiletID)")
                return
            }

            guard let data = document.data(),
                  let reviews = data["reviews"] as? [[String: Any]] else {
                print("No 'reviews' field or data in toilet document: \(toiletID)")
                return
            }

            print("Fetched reviews for toilet \(toiletID): \(reviews)")

            // If no reviews, set rating to 0
            if reviews.isEmpty {
                print("No reviews found. Setting rating to 0 for toilet \(toiletID).")
                toiletRef.updateData(["rating": 0]) { error in
                    if let error = error {
                        print("Error updating rating to 0: \(error)")
                    } else {
                        print("Rating successfully updated to 0 for toilet \(toiletID).")
                    }
                }
                return
            }

            // Calculate average rating
            let ratings = reviews.compactMap { $0["rating"] as? Int }
            let averageRating = Double(ratings.reduce(0, +)) / Double(ratings.count)

            print("Calculated average rating for toilet \(toiletID): \(averageRating)")

            // Update the average rating in Firestore
            toiletRef.updateData(["rating": averageRating]) { error in
                if let error = error {
                    print("Error updating average rating: \(error)")
                } else {
                    print("Average rating successfully updated for toilet \(toiletID): \(averageRating)")
                }
            }
        }
    }




    private func loadToilets() {
        print("🚀 Starting to load toilets...")
        // loading default toilets
        toilets = Array(DefaultToilets.toilets.prefix(3))
        print("📍 Loaded \(toilets.count) default toilets")
        
        if let user = Auth.auth().currentUser {
            print("User is logged in: \(user.email ?? "unknown")")
            
            db.collection("toilets").getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching toilets: \(error)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    print("📄 Found \(documents.count) documents in Firestore")
                    
                    let firestoreToilets = documents.compactMap { doc -> Toilet? in
                        do {
                            let toilet = try doc.data(as: Toilet.self)
                            print("Successfully decoded toilet: \(toilet.name)")
                            return toilet
                        } catch {
                            print("Failed to decode document: \(error)")
                            return nil
                        }
                    }
                    
                    // combine default toilets and toilets from the firebase
                    self?.toilets.append(contentsOf: firestoreToilets)
                    print("🎯 Total toilets after merge: \(self?.toilets.count ?? 0)")
                    
                    // loading
                    DispatchQueue.main.async {
                        self?.searchBottomSheet.tableViewSearchResults.reloadData()
                        print("🔄 Table view reloaded")
                    }
                }
            }
        } else {
            print("No user logged in")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension SearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    var ratingOptions: [(String, Int)] {
        return [
            ("Great Facilities", 5),
            ("Good", 4),
            ("Acceptable", 3),
            ("Unclean/Poor Facilities", 2),
            ("Unacceptable", 1)
        ]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return ratingOptions.count
        } else if pickerView == self.reportPickerView {
            return reportOptions.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            return ratingOptions[row].0
        } else if pickerView == self.reportPickerView {
            return reportOptions[row]
        }
        return nil
    }
}





