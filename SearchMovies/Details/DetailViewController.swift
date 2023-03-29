//
//  DetailViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 28.03.2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
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
        label.font = UIFont(name: "Gill Sans", size: 25)
        label.textColor = .black
        label.text = "Something"
        return label
    }()
    
    lazy var yearMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.textColor = .black
        label.text = "1998"
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.textColor = .black
        label.text = "Horror"
        return label
    }()
    
    lazy var DescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
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
        view.addSubview(DescriptionLabel)
        movieImage.backgroundColor = .red
        view.backgroundColor = .white
        setConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share(sender:)))
        
    }
    
    
    //MARK: Layout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            movieImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            movieImage.widthAnchor.constraint(equalToConstant: 200),
            movieImage.heightAnchor.constraint(equalToConstant: 200),
            nameMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            nameMovieLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            genreLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            genreLabel.topAnchor.constraint(equalTo: nameMovieLabel.bottomAnchor, constant: 20),
            yearMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            yearMovieLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            DescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            DescriptionLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 15),
            DescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.1),
            //  DescriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2)
        ])
    }
    
    
    @objc func share(sender:UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out my app"
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
}
