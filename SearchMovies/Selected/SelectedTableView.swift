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
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTableViewCell", for: indexPath) as! MovieCell
        cell.imageMovie.backgroundColor = .red
        cell.nameLabel.text = "Something"
        cell.genreLabel.text = "Horror"
        cell.yearLabel.text = "1998"
        cell.addToSelectedButton.isHidden = true
        
        cell.nameLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.023)
        cell.genreLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        cell.yearLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}
