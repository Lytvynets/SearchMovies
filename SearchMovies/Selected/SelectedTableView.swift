//
//  SelectedTableView.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 28.03.2023.
//

import Foundation
import UIKit

//MARK: - Work with table view
extension SelectedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.selectedMoviesArray?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTableViewCell", for: indexPath) as! MovieCell
        cell.selectionStyle = .none
        let array = dataManager.selectedMoviesArray[indexPath.row]
        let imageUrl = URL(string: array.imageUrl)!
        
        cell.nameLabel.text = array.name
        cell.genreLabel.text = array.genre
        cell.yearLabel.text = array.date
        cell.imageMovie.backgroundColor = .gray
        cell.imageMovie.load(url: imageUrl)
        cell.addToSelectedButton.isHidden = true
        cell.nameLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.023)
        cell.genreLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        cell.yearLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let array = dataManager.selectedMoviesArray[indexPath.row]
        let imageUrl = URL(string: array.imageUrl )!
        vc.movieImage.load(url: imageUrl)
        vc.descriptionText.text = array.descriptionMovie
        vc.genreLabel.text = array.genre
        vc.yearMovieLabel.text = array.date
        vc.shareUrlMovie = array.urlString
        vc.nameMovieLabel.text = array.name
        let navCon = UINavigationController(rootViewController: vc)
        self.present(navCon, animated: true)
    }
    
    
    // Delete Cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let debtors = dataManager.selectedMoviesArray[indexPath.row]
        dataManager.deleteFromRealm(debtor: debtors, tableView: tableView)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
