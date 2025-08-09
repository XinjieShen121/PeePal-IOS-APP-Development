//
//  SearchBottomSheet.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import UIKit

class SearchBottomSheet: UIView {
    var tableViewSearchResults: UITableView!

    private let fixedHeight: CGFloat = 350
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableViewSearchResults()
        setupAppearance()
        initConstraints()
    }

    func setupTableViewSearchResults() {
        tableViewSearchResults = UITableView()
        tableViewSearchResults.register(SearchTableViewCell.self, forCellReuseIdentifier: Configs.searchTableViewID)
        tableViewSearchResults.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewSearchResults.alwaysBounceVertical = true
        tableViewSearchResults.showsVerticalScrollIndicator = true
           
        tableViewSearchResults.bounces = true
        
        self.addSubview(tableViewSearchResults)
    }
    
    private func setupAppearance() {
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: fixedHeight),
            
            tableViewSearchResults.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableViewSearchResults.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableViewSearchResults.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewSearchResults.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
