//
//  SelectedViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import UIKit
import RealmSwift

class SelectedViewController: UIViewController {
    
    let dataManager = DataManager()
    
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
        let realm = try! Realm()
        dataManager.selectedMoviesArray = realm.objects(Selected.self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableView.reloadData()
    }
    
    
    private func tableViewSettings() {
        mainTableView.register(MovieCell.self, forCellReuseIdentifier: "SelectedTableViewCell")
        mainTableView.layer.cornerRadius = 15
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
