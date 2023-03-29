//
//  Model.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 29.03.2023.
//

import Foundation

struct SearchResponse: Codable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Codable {
    var trackName: String
    var kind: String
    var primaryGenreName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
    var releaseDate: String
    var longDescription: String
}
