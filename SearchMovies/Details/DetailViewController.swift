//
//  DetailViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 28.03.2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var shareUrlMovie = ""
    
    lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.layer.cornerRadius = 5
        return image
    }()
    
    lazy var nameMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.textColor = .black
        label.text = "Something"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yearMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 15)
        label.textColor = .black
        label.text = "1998"
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 18)
        label.textColor = .black
        label.text = "Horror"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror Horror"
        return label
    }()
    
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(movieImage)
        view.addSubview(nameMovieLabel)
        view.addSubview(yearMovieLabel)
        view.addSubview(genreLabel)
        view.addSubview(descriptionLabel)
        movieImage.backgroundColor = .red
        view.backgroundColor = .white
        setConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
    }
    
    
    //MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            movieImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            movieImage.widthAnchor.constraint(equalToConstant: 100),
            movieImage.heightAnchor.constraint(equalToConstant: 150),
            nameMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            nameMovieLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            nameMovieLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.7),
            genreLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            genreLabel.bottomAnchor.constraint(equalTo: yearMovieLabel.topAnchor, constant: -20),
            yearMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            yearMovieLabel.bottomAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: -5),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 15),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.1),
        ])
    }
    
    
    //MARK: - Actions
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let myWebsite = URL(string: shareUrlMovie) {
            let objectsToShare = [myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
}
