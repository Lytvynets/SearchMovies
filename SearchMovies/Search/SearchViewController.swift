//
//  ViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let mainTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainTableView)
        view.backgroundColor = .white
        setupSearchBar()
        setConstraints()
        tableViewSettings()
        
        //        let vc = AuthenticationViewController()
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true)
        
    }
    
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //          let vc = AuthenticationViewController()
        //          vc.modalPresentationStyle = .fullScreen
        //          self.present(vc, animated: true)
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
        mainTableView.register(MovieCell.self, forCellReuseIdentifier: "TableViewCell")
        mainTableView.layer.cornerRadius = 15
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
}

