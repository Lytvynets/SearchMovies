//
//  DataManager.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 01.04.2023.
//

import Foundation
import RealmSwift

class DataManager {
    
    var realm = try! Realm()
    var selectedMoviesArray: Results<Selected>!
    var historyMoviesArray: Results<History>!
    
    
    func saveToRealm(debtor: Selected){
        try! realm.write{
            realm.add(debtor)
        }
    }
    
    
    
    func saveToRealmHistory(debtor: History){
        try! realm.write{
            realm.add(debtor)
        }
    }
    
    
    func deleteFromRealmHistory(debtor: History, tableView: UITableView){
        try! realm.write{
            realm.delete(debtor)
            tableView.reloadData()
        }
    }
    
    
    func deleteFromRealm(debtor: Selected, tableView: UITableView){
        try! realm.write{
            realm.delete(debtor)
            tableView.reloadData()
        }
    }
}
