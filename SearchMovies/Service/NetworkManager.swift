//
//  NetworkManager.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var movieArray = [Track]()
    
    func fetchTracks(searchText: String, complition: @escaping (SearchResponse?) -> Void ){
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                          "limit":"10",
                          "media":"movie"
        ]
        
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let error = dataResponse.error {
                print("Error data: \(error.localizedDescription)")
                complition(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            let jsonDecod = JSONDecoder()
            
            do{
                let object = try jsonDecod.decode(SearchResponse.self, from: data)
                // print("Object:", object)
                self.movieArray = object.results
                complition(object)
                
            } catch let jsonError{
                print(jsonError)
                complition(nil)
            }
        }
    }
}
