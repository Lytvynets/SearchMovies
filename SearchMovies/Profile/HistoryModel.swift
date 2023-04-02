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
    @objc dynamic var genre = ""
    
    convenience init(name: String, genre: String) {
        self.init()
        self.name = name
        self.genre = genre
    }
}
