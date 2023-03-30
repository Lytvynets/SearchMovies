//
//  ProfileViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    let networkManager = NetworkManager()
    let ref = Database.database().reference()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .red
        return image
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.textColor = .black
        label.text = "Vladyslav"
        return label
    }()
    
    
    lazy var secondNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 20)
        label.text = "Lytvynets"
        label.textColor = .black
        return label
    }()
    
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(secondNameLabel)
        view.addSubview(logOutButton)
        setConstraints()
    }
    
    @objc private func logOutAction() {
        print("Log out")
        do{
            try Auth.auth().signOut()
            self.showAuthentication()
        }catch{
            print(error)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        test()
    }
    
    
    func test() {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        let ref = Database.database().reference().child("users")
        ref.child(id).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? "nil"
            let secondName = value?["secondName"] as? String ?? "nil"
            let user = User(name: username, secondName: secondName)
            self.nameLabel.text = user.name
            self.secondNameLabel.text = user.secondName
            print(username)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    
    private func showAuthentication() {
        let vc = AuthenticationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    private func setConstraints() {
        profileImage.layer.cornerRadius = 50
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 7),
            secondNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
        ])
    }
}
