//
//  HistoryCell.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 01.04.2023.
//

import Foundation
import UIKit

class HistoryCell: UITableViewCell {
    
    let dataManager = DataManager()
    
    lazy var nameLabel = LabelBuilder(fontSize: 20, startText: "Name", color: .black)
    lazy var dateLabel = LabelBuilder(fontSize: 15, startText: "Date", color: .gray)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2.5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3),
        ])
    }
}
