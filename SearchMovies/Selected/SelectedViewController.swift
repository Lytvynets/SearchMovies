//
//  SelectedViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import UIKit

class SelectedViewController: UIViewController {
    
    let mainTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainTableView)
        setConstraints()
        tableViewSettings()
    }
    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    private func tableViewSettings() {
        mainTableView.register(MovieCell.self, forCellReuseIdentifier: "SelectedTableViewCell")
        mainTableView.layer.cornerRadius = 15
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
}
