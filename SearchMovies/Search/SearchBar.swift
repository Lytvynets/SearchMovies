//
//  SearchBar.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 02.04.2023.
//

import Foundation
import UIKit

//MARK: - SearchBarDelegate
extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let now = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        let dateTime = dateFormater.string(from: now)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            print(searchText)
            self?.networkManager.fetchTracks(searchText: searchText, complition: { movie in
                self?.arrayMovie = movie?.results ?? []
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    let history = History(name: searchText, genre: dateTime)
                    self?.dataManager.saveToRealmHistory(debtor: history)
                }
                self?.SearchTableView.reloadData()
            })
        })
    }
}
