//
//  SelectedModel.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 02.04.2023.
//

import Foundation
import RealmSwift

class Selected: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var genre = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var descriptionMovie = ""
    @objc dynamic var urlString = ""
    @objc dynamic var date = ""
    
    convenience init(name: String, genre: String, descriptionMovie: String, urlString: String, date: String, imageUrl: String) {
        self.init()
        self.name = name
        self.genre = genre
        self.imageUrl = imageUrl
        self.descriptionMovie = descriptionMovie
        self.urlString = urlString
        self.date = date
    }
}
