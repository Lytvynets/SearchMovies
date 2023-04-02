//
//  ViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    let searchController = UISearchController(searchResultsController: nil)
    var arrayMovie = [Track]()
    var timer: Timer?
    
    
    let SearchTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(SearchTableView)
        view.backgroundColor = .white
        setupSearchBar()
        setConstraints()
        tableViewSettings()
        let realm = try! Realm()
        dataManager.historyMoviesArray = realm.objects(History.self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.showAuthentication()
            }
        }
    }
    
    
    private func showAuthentication() {
        let vc = AuthenticationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
    private func tableViewSettings() {
        SearchTableView.register(MovieCell.self, forCellReuseIdentifier: "TableViewCell")
        SearchTableView.layer.cornerRadius = 15
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            SearchTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            SearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            SearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
