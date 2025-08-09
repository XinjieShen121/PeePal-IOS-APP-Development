//
//  MyAddedToiletsScreenView.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 12/1/24.
//

import UIKit

class MyAddedToiletsScreenView: UIView {
    // MARK: - UI Components
    var tableView: UITableView!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 0.894, blue: 0.608, alpha: 1.0) // Set background color HEX: #ffe49b
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MyAddedToiletsTableViewCell.self, forCellReuseIdentifier: MyAddedToiletsTableViewCell.reuseIdentifier)
        self.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

