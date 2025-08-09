//
//  MapView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/17/24.
//
import UIKit
import MapKit

class MapView: UIView {
    var mapView: MKMapView!
    var buttonLoading: UIButton!
    var buttonCurrentLocation: UIButton!
    var buttonSearch: UIButton!
    var buttonAdd: UIButton!
    var buttonProfile: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black // Matches dark theme
        setupMapView()
        setupButtonLoading()
        setupButtonCurrentLocation()
        setupButtonAdd()
        setupButtonProfile()
        setupButtonSearch()
        initConstraints()
    }
    
    func setupMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .mutedStandard // Darker map theme
        mapView.showsUserLocation = true
        self.addSubview(mapView)
    }
    
    func setupButtonLoading() {
        buttonLoading = UIButton(type: .system)
        buttonLoading.setTitle(" Fetching Location...  ", for: .normal)
        buttonLoading.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonLoading.setImage(UIImage(systemName: "circle.dotted"), for: .normal)
        buttonLoading.backgroundColor = UIColor.darkGray
        buttonLoading.tintColor = .white
        buttonLoading.layer.cornerRadius = 10
        buttonLoading.layer.shadowOffset = .zero
        buttonLoading.layer.shadowRadius = 4
        buttonLoading.layer.shadowOpacity = 0.5
        buttonLoading.translatesAutoresizingMaskIntoConstraints = false
        buttonLoading.isEnabled = false
        self.addSubview(buttonLoading)
    }
    
    func setupButtonCurrentLocation() {
        buttonCurrentLocation = UIButton(type: .system)
        buttonCurrentLocation.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        buttonCurrentLocation.backgroundColor = UIColor.darkGray
        buttonCurrentLocation.tintColor = .white
        buttonCurrentLocation.layer.cornerRadius = 18
        buttonCurrentLocation.layer.shadowOffset = .zero
        buttonCurrentLocation.layer.shadowRadius = 4
        buttonCurrentLocation.layer.shadowOpacity = 0.5
        buttonCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCurrentLocation)
    }
    
    func setupButtonAdd() {
        buttonAdd = UIButton(type: .system)
        buttonAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        buttonAdd.backgroundColor = UIColor.darkGray
        buttonAdd.tintColor = .white
        buttonAdd.layer.cornerRadius = 18
        buttonAdd.layer.shadowOffset = .zero
        buttonAdd.layer.shadowRadius = 4
        buttonAdd.layer.shadowOpacity = 0.5
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAdd)
    }
    
    func setupButtonProfile() {
        buttonProfile = UIButton(type: .system)
        buttonProfile.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        buttonProfile.backgroundColor = UIColor.darkGray
        buttonProfile.tintColor = .white
        buttonProfile.layer.cornerRadius = 18
        buttonProfile.layer.shadowOffset = .zero
        buttonProfile.layer.shadowRadius = 4
        buttonProfile.layer.shadowOpacity = 0.5
        buttonProfile.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonProfile)
    }
    
    func setupButtonSearch() {
        buttonSearch = UIButton(type: .system)
        buttonSearch.setTitle("Browse Toilets", for: .normal)
        buttonSearch.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonSearch.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        buttonSearch.backgroundColor = UIColor.darkGray
        buttonSearch.tintColor = .white
        buttonSearch.layer.cornerRadius = 10
        buttonSearch.layer.shadowOffset = .zero
        buttonSearch.layer.shadowRadius = 4
        buttonSearch.layer.shadowOpacity = 0.5
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSearch)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Full-screen map view
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // Center loading button
            buttonLoading.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            buttonLoading.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            buttonLoading.widthAnchor.constraint(equalToConstant: 240),
            buttonLoading.heightAnchor.constraint(equalToConstant: 40),
            
            // Current location button (top-right, below status bar)
            buttonCurrentLocation.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            buttonCurrentLocation.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 0),
            buttonCurrentLocation.heightAnchor.constraint(equalToConstant: 36),
            buttonCurrentLocation.widthAnchor.constraint(equalToConstant: 36),
            
            // Add button (below current location button)
            buttonAdd.topAnchor.constraint(equalTo: buttonCurrentLocation.bottomAnchor, constant: 16),
            buttonAdd.trailingAnchor.constraint(equalTo: buttonCurrentLocation.trailingAnchor),
            buttonAdd.heightAnchor.constraint(equalToConstant: 36),
            buttonAdd.widthAnchor.constraint(equalToConstant: 36),
            
            // Profile button (top-left, below status bar)
            buttonProfile.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16),
            buttonProfile.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 0),
            buttonProfile.heightAnchor.constraint(equalToConstant: 36),
            buttonProfile.widthAnchor.constraint(equalToConstant: 36),
            
            // Search button (center bottom)
            buttonSearch.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonSearch.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
            buttonSearch.heightAnchor.constraint(equalToConstant: 40),
            buttonSearch.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
