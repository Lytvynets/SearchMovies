//
//  Extensions.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 02.04.2023.
//

import Foundation
import UIKit


//MARK: - image url
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
