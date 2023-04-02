//
//  HistoryModel.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 02.04.2023.
//

import RealmSwift
import Foundation

class History: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    
    convenience init(name: String, date: String) {
        self.init()
        self.name = name
        self.date = date
    }
}
