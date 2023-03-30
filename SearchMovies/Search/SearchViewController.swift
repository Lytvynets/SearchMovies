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

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let networkManager = NetworkManager()
    let searchController = UISearchController(searchResultsController: nil)
    var arrayMovie = [Track]()
    private var timer: Timer?
    
    
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
    
    
    private func setConstraints() {
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


//MARK: - SearchBarDelegate
extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            print(searchText)
            self?.networkManager.fetchTracks(searchText: searchText, complition: { movie in
                self?.arrayMovie = movie?.results ?? []
                self?.mainTableView.reloadData()
            })
        })
    }
}
