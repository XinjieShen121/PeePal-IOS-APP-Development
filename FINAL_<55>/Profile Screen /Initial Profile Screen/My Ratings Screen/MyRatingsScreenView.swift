//
//  MyRatingsScreenView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/30/24.
//

import UIKit

class MyRatingsScreenView: UIView {
    // MARK: - UI Components
    var tableView: UITableView!
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // Set background color HEX: #ffe49b
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(MyRatingsTableViewCell.self, forCellReuseIdentifier: MyRatingsTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

