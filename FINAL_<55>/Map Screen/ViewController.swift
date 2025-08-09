//
//  ViewController.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/17/24.
//
import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class ViewController: UIViewController {
    let mapView = MapView()
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    
    var toilets: [Toilet] = []
    var handleAuth: AuthStateDidChangeListenerHandle?

    // MARK: - View Lifecycle
    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mapView.mapView.delegate = self
        
        setupActions()
        setupLocationManager()
        
        // Observe UserLoggedOut notification
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleUserLoggedOut),
                name: Notification.Name("UserLoggedOut"),
                object: nil
        )
        
        observeAuthState()
        
        // Recalculate all toilet ratings on app launch
        print("Starting to recalculate all toilet ratings...")
        recalculateAllToiletsAverageRating()
        
        
        
        // Add observer for ToiletSelected notification
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleToiletSelectedNotification(_:)),
                name: Notification.Name("ToiletSelected"),
                object: nil
        )
    
        loadToilets()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ToiletSelected"), object: nil)
    }
    
    @objc private func handleUserLoggedOut() {
        print("User logged out. Refreshing annotations.")
        // Clear all existing annotations
        mapView.mapView.removeAnnotations(mapView.mapView.annotations)
        
        // Load only the default toilets
        self.toilets = Array(DefaultToilets.toilets.prefix(3))
        self.addToiletAnnotations(toilets: self.toilets)
    }
    
    func sortToiletsByProximity() {
        guard let userLocation = locationManager.location else { return }
        
        toilets.sort { toilet1, toilet2 in
            let location1 = CLLocation(latitude: toilet1.location.latitude, longitude: toilet1.location.longitude)
            let location2 = CLLocation(latitude: toilet2.location.latitude, longitude: toilet2.location.longitude)
            
            return userLocation.distance(from: location1) < userLocation.distance(from: location2)
        }
        print("Sorted toilets: \(toilets.map { $0.name })")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Add delay to ensure SearchViewController is ready
            NotificationCenter.default.post(
                name: Notification.Name("ToiletsUpdated"),
                object: nil,
                userInfo: ["toilets": self.toilets]
            )
            print("Notification posted: ToiletsUpdated")
        }
    }


    
    // Handle the notification
    @objc private func handleToiletSelectedNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let latitude = userInfo["latitude"] as? Double,
              let longitude = userInfo["longitude"] as? Double,
              let name = userInfo["name"] as? String else {
            print("Error: Missing or invalid notification data")
            return
        }
        
        // Center the map on the selected toilet's location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.mapView.centerToLocation(location: CLLocation(latitude: latitude, longitude: longitude))
        
        // Find and select the corresponding annotation
        if let annotations = mapView.mapView.annotations as? [MKPointAnnotation],
           let annotation = annotations.first(where: { $0.title == name }) {
            mapView.mapView.selectAnnotation(annotation, animated: true)
        } else {
            print("Annotation not found for toilet: \(name)")
        }
    }

    // MARK: - Recalculate All Toilets Ratings
    private func recalculateAllToiletsAverageRating() {
        print("Starting recalculation for all toilets...")

        let toiletsRef = db.collection("toilets")

        toiletsRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching toilets for recalculation: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No toilet documents found for recalculation.")
                return
            }

            print("Fetched \(documents.count) toilet documents for recalculation.")

            for document in documents {
                let toiletID = document.documentID
                print("Recalculating rating for toilet ID: \(toiletID)")
                self.updateToiletAverageRating(toiletID: toiletID)
            }
        }
    }

    private func updateToiletAverageRating(toiletID: String) {
        print("Updating average rating for toilet ID: \(toiletID)")

        let toiletRef = db.collection("toilets").document(toiletID)

        toiletRef.getDocument { [weak self] documentSnapshot, error in
            if let error = error {
                print("Error fetching toilet data for \(toiletID): \(error)")
                return
            }

            guard let document = documentSnapshot, document.exists else {
                print("Toilet document not found for ID: \(toiletID)")
                return
            }

            guard let data = document.data(),
                  let reviews = data["reviews"] as? [[String: Any]] else {
                print("No 'reviews' field found for toilet \(toiletID). Setting rating to 0.")
                toiletRef.updateData(["rating": 0]) { error in
                    if let error = error {
                        print("Error updating rating to 0 for \(toiletID): \(error)")
                    } else {
                        print("Rating successfully set to 0 for toilet \(toiletID).")
                    }
                }
                return
            }

            print("Fetched reviews for toilet \(toiletID): \(reviews)")

            if reviews.isEmpty {
                print("No reviews found. Setting rating to 0 for toilet \(toiletID).")
                toiletRef.updateData(["rating": 0]) { error in
                    if let error = error {
                        print("Error updating rating to 0 for \(toiletID): \(error)")
                    } else {
                        print("Rating successfully updated to 0 for toilet \(toiletID).")
                    }
                }
                return
            }

            let ratings = reviews.compactMap { $0["rating"] as? Int }
            let averageRating = Double(ratings.reduce(0, +)) / Double(ratings.count)

            print("Calculated average rating for toilet \(toiletID): \(averageRating)")

            toiletRef.updateData(["rating": averageRating]) { error in
                if let error = error {
                    print("Error updating average rating for \(toiletID): \(error)")
                } else {
                    print("Successfully updated average rating for toilet \(toiletID): \(averageRating)")
                }
            }
        }
    }

    // MARK: - Button Actions
    private func setupActions() {
        mapView.buttonCurrentLocation.addTarget(self, action: #selector(onButtonCurrentLocationTapped), for: .touchUpInside)
        mapView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
        mapView.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
        mapView.buttonProfile.addTarget(self, action: #selector(onButtonProfileTapped), for: .touchUpInside)
    }

    @objc private func onButtonCurrentLocationTapped() {
        if let location = locationManager.location {
            mapView.mapView.centerToLocation(location: location)
        }
    }
    
    @objc private func onButtonAddTapped() {
        let addToiletVC = AddToiletViewController()
        addToiletVC.delegate = self
        let navController = UINavigationController(rootViewController: addToiletVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
    }

    @objc private func onButtonSearchTapped() {
        let searchVC = SearchViewController()
        searchVC.delegateToMapView = self
        let navVC = UINavigationController(rootViewController: searchVC)
        navVC.modalPresentationStyle = .pageSheet
        
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        // Trigger the sort and post notification after the observer is set up
        self.sortToiletsByProximity()
        
        // Present the SearchViewController and wait for it to set up the observer
        present(navVC, animated: true) {
            // Delay the notification posting to ensure the observer is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
 
            }
        }
    }

    
    @objc private func onButtonProfileTapped() {
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        present(navController, animated: true)
    }

    private func loadToilets() {
        let isUserLoggedIn = Auth.auth().currentUser != nil

        if !isUserLoggedIn {
            self.toilets = Array(DefaultToilets.toilets.prefix(3))
            sortToiletsByProximity()
            addToiletAnnotations(toilets: toilets)
            return
        }

        db.collection("toilets").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching toilets: \(error)")
                return
            }

            let firestoreToilets = snapshot?.documents.compactMap { doc -> Toilet? in
                try? doc.data(as: Toilet.self)
            } ?? []

            self.toilets = Array(DefaultToilets.toilets.prefix(3)) + firestoreToilets
            //self.sortToiletsByProximity() // Sort after loading data
            self.addToiletAnnotations(toilets: self.toilets)
        }
    }


    // MARK: - Add Annotations to Map
    private func addToiletAnnotations(toilets: [Toilet]) {
        for toilet in toilets {
            let annotation = MKPointAnnotation()
            annotation.title = toilet.name
            annotation.subtitle = toilet.address
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: toilet.location.latitude,
                longitude: toilet.location.longitude
            )
            mapView.mapView.addAnnotation(annotation)
        }
        print("Annotations added: \(mapView.mapView.annotations.count)")
    }

    // MARK: - Observe User Auth State
    private func observeAuthState() {
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                print("User is not signed in. Loading default toilets.")
                self.toilets = Array(DefaultToilets.toilets.prefix(3))
                self.addToiletAnnotations(toilets: self.toilets)
            } else {
                print("User is signed in: \(user?.email ?? "Unknown Email"). Loading Firestore toilets.")
                self.loadToilets()
            }
        }
    }
}

// MARK: - AddToiletViewControllerDelegate
extension ViewController: AddToiletViewControllerDelegate {
    func didAddToilet() {
        print("Delegate called: Reloading toilets.")
        loadToilets()
    }
}


