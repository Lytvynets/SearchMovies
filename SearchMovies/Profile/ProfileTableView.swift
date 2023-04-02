//
//  ProfileTableView.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 01.04.2023.
//

import Foundation
import UIKit

//MARK: - Work with table view
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.historyMoviesArray?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let array = dataManager.historyMoviesArray[indexPath.row]
        cell.nameLabel.text = array.name
        cell.dateLabel.text = array.date
        cell.selectionStyle = .none
        cell.nameLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        cell.dateLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.017)
        return cell
    }
    
    
    // Delete Cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let debtors = dataManager.historyMoviesArray[indexPath.row]
        dataManager.deleteFromRealmHistory(object: debtors, tableView: tableView)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 17
    }
    
}
