//
//  TolietDetailViewController.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/26/24.
//


import UIKit
import FirebaseFirestore

class ToiletDetailViewController: UIViewController {
    var toilet: Toilet
    private var detailView: ToiletDetailView!
    let db = Firestore.firestore()
    
    init(toilet: Toilet) {
        self.toilet = toilet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        detailView = ToiletDetailView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configureView(toilet: toilet)
        fetchAndUpdateRating()
        checkForReports()
    }
    
    // Fetch rating from Firestore
    func fetchAndUpdateRating() {
        guard let toiletID = toilet.id else {
            print("Toilet ID not found")
            return
        }
        
        db.collection("toilets").document(toiletID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching toilet data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let rating = data["rating"] as? Double else {
                print("No rating found for toilet \(toiletID)")
                return
            }
            
            DispatchQueue.main.async {
                self.detailView.rateTitleLabel.text = String(format: "Rating: %.1f", rating)
            }
        }
    }
    
    // Check for reports and update UI with a warning if reports exist
    func checkForReports() {
        guard let toiletID = toilet.id else {
            print("Toilet ID not found")
            return
        }
        
        db.collection("toilets").document(toiletID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching toilet data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let reports = data["reports"] as? [[String: Any]], !reports.isEmpty else {
                print("No reports found for toilet \(toiletID)")
                return
            }
            
            // Extract report reasons
            let reportReasons = reports.compactMap { $0["reportReason"] as? String }
            
            // Create a detailed warning message
            let warningMessage: String
            if reportReasons.isEmpty {
                warningMessage = "This toilet has been reported recently! Please double-check its condition before use."
            } else {
                let reasons = reportReasons.joined(separator: ", ")
                warningMessage = """
                This toilet has been reported recently! Please double-check its condition before use.
                Reports include the following issues: \(reasons).
                """
            }
            
            // Update the UI with the warning
            DispatchQueue.main.async {
                self.detailView.showWarning(warningMessage)
            }
        }
    }

}


