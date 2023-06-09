//
//  SearchTableView.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 28.03.2023.
//

import Foundation
import UIKit

//MARK: - Work with table view
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMovie.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MovieCell
        cell.imageMovie.backgroundColor = .gray
        cell.selectionStyle = .none
        
        let array = arrayMovie[indexPath.row]
        let imageUrl = URL(string: array.artworkUrl100 ?? "")!
        
        cell.imageMovie.load(url: imageUrl)
        cell.nameLabel.text = array.trackName
        cell.genreLabel.text = array.primaryGenreName
        cell.yearLabel.text = array.releaseDate
        
        cell.name = array.trackName
        cell.genre = array.primaryGenreName
        cell.year = array.releaseDate
        cell.longDescription = array.longDescription
        cell.imageUrl = array.artworkUrl100 ?? ""
        cell.previewUrl = array.previewUrl ?? ""
        
        cell.nameLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.023)
        cell.genreLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        cell.yearLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let array = arrayMovie[indexPath.row]
        let imageUrl = URL(string: array.artworkUrl100 ?? "")!
        vc.movieImage.load(url: imageUrl)
        vc.descriptionText.text = array.longDescription
        vc.genreLabel.text = array.primaryGenreName
        vc.yearMovieLabel.text = array.releaseDate
        vc.shareUrlMovie = array.previewUrl ?? ""
        vc.nameMovieLabel.text = array.trackName
        let navCon = UINavigationController(rootViewController: vc)
        self.present(navCon, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
