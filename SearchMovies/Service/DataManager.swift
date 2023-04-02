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
    
    
    func saveToRealm(object: Selected){
        try! realm.write{
            realm.add(object)
        }
    }
    
    
    func saveToRealmHistory(object: History){
        try! realm.write{
            realm.add(object)
        }
    }
    
    
    func deleteFromRealmHistory(object: History, tableView: UITableView){
        try! realm.write{
            realm.delete(object)
            tableView.reloadData()
        }
    }
    
    
    func deleteFromRealm(object: Selected, tableView: UITableView){
        try! realm.write{
            realm.delete(object)
            tableView.reloadData()
        }
    }
}
