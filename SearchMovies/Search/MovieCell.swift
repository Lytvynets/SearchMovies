//
//  MovieCell.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 28.03.2023.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    lazy var imageMovie: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.textColor = .black
        return label
    }()
    
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 15)
        label.textColor = .gray
        return label
    }()
    
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 15)
        label.textColor = .gray
        return label
    }()
    
    
    lazy var addToSelectedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageMovie)
        contentView.addSubview(nameLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(addToSelectedButton)
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageMovie.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageMovie.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/7),
            imageMovie.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/1.2),
            nameLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/1.7),
            genreLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 10),
            genreLabel.bottomAnchor.constraint(equalTo: yearLabel.topAnchor, constant: -7),
            genreLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            yearLabel.leadingAnchor.constraint(equalTo: imageMovie.trailingAnchor, constant: 10),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            yearLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            addToSelectedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addToSelectedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
}
