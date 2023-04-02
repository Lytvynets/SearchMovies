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
    
    lazy var nameMovieLabel = LabelBuilder(fontSize: 20, startText: "Something", color: .black)
    lazy var yearMovieLabel = LabelBuilder(fontSize: 15, startText: "2004", color: .black)
    lazy var genreLabel = LabelBuilder(fontSize: 18, startText: "Horror", color: .black)
    lazy var descriptionText = LabelBuilder(fontSize: 17, startText: "Description Text", color: .black)
    lazy var descriptionLabel = LabelBuilder(fontSize: 17, startText: "Description", color: .black)
    
    
    lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.layer.cornerRadius = 5
        return image
    }()
    
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(movieImage)
        view.addSubview(nameMovieLabel)
        view.addSubview(yearMovieLabel)
        view.addSubview(genreLabel)
        view.addSubview(descriptionText)
        view.addSubview(descriptionLabel)
        movieImage.backgroundColor = .gray
        view.backgroundColor = .white
        setConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(sender:)))
        fontSettings()
        descriptionText.numberOfLines = 0
        nameMovieLabel.numberOfLines = 0
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
            genreLabel.bottomAnchor.constraint(equalTo: yearMovieLabel.topAnchor, constant: -12),
            yearMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            yearMovieLabel.bottomAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: -5),
            descriptionLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.1),
        ])
    }
    
    
    //Font setting
    private func fontSettings() {
        nameMovieLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.024)
        yearMovieLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.018)
        genreLabel.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.022)
        descriptionLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.024)
        descriptionText.font = UIFont(name: "Gill Sans", size: view.frame.height * 0.021)
    }
    
    
    
    //MARK: - Actions
    @objc func share(sender: UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let myWebsite = URL(string: shareUrlMovie) {
            let objectsToShare = [myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
