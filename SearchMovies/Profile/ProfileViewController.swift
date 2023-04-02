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
import FirebaseStorage
import RealmSwift

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let dataManager = DataManager()
    let networkManager = NetworkManager()
    let ref = Database.database().reference()
    let picker = UIImagePickerController()
    
    private lazy var nameLabel = LabelBuilder(fontSize: 20, startText: "Name", color: .black)
    private lazy var secondNameLabel = LabelBuilder(fontSize: 20, startText: "Second name", color: .black)
    private lazy var imageSavedLabel = LabelBuilder(fontSize: 15, startText: "Image Saved!", color: .black)
    private lazy var historyLabel = LabelBuilder(fontSize: 15, startText: "Search history", color: .black)
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.black.cgColor
        return image
    }()
    
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(addPhotoButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(uploadPhotoButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(secondNameLabel)
        view.addSubview(logOutButton)
        view.addSubview(addPhotoButton)
        view.addSubview(savePhotoButton)
        view.addSubview(activityIndicator)
        view.addSubview(imageSavedLabel)
        view.addSubview(mainTableView)
        view.addSubview(historyLabel)
        labelSettings()
        setConstraints()
        fontSettings()
        tableViewSettings()
        let realm = try! Realm()
        dataManager.historyMoviesArray = realm.objects(History.self)
        self.picker.delegate = self
        self.picker.allowsEditing = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableView.reloadData()
        getPersonalData()
    }
    
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height / 2
    }
    
    
    //MARK: - Adding a profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImage.image = originImage
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    
    private func addImgData() {
        let img = profileImage.image
        let storageRef = Storage.storage().reference()
        guard let id = Auth.auth().currentUser?.uid else { return }
        guard let image = profileImage.image?.imageAsset?.value(forKey: "assetName") else { return }
        let riversRef = storageRef.child("Images /\(image).jpg")
        let ref = Database.database().reference().child("users")
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        ref.child(id).updateChildValues(["imageName": "\(image).jpg"])
        riversRef.putData((img?.pngData())!, metadata: nil) { (metadata, error) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 2.0) {
                self.imageSavedLabel.alpha = 1
                UIView.animate(withDuration: 5.0) {
                    self.imageSavedLabel.alpha = 0
                }
            }
        }
    }
    
    
    //MARK: - Get User data
    private func getPersonalData() {
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else { return }
        let ref = Database.database().reference().child("users")
        ref.child(id).observeSingleEvent(of: .value, with: { snapshot in
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? "nil"
            let secondName = value?["secondName"] as? String ?? "nil"
            let useImage = value?["imageName"] as? String ?? "nil"
            self.nameLabel.text = username
            self.secondNameLabel.text = secondName
            self.getImage(name: useImage) { img in
                DispatchQueue.main.async {
                    self.profileImage.image = img
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    
    private func getImage(name: String, completion: @escaping (UIImage) -> Void){
        let storageRef = Storage.storage()
        let reference = storageRef.reference()
        let refPath = reference.child("Images /")
        var image = UIImage(systemName: "photo.circle")
        let fileRef = refPath.child(name)
        fileRef.getData(maxSize: 4288*2848) { data, error in
            guard error == nil else {completion(image!); return }
            image = UIImage(data: data!)!
            completion(image!)
        }
    }
    
    
    
    //MARK: - Actions
    @objc private func logOutAction() {
        do{
            try Auth.auth().signOut()
            self.showAuthentication()
        }catch{
            print(error)
        }
    }
    
    
    @objc func addPhotoButtonAction() {
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    
    @objc func uploadPhotoButtonAction() {
        addImgData()
    }
    
    
    //MARK: - Some settings
    private func fontSettings() {
        imageSavedLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.02)
        historyLabel.font = UIFont(name: "Apple Symbols", size: view.frame.height * 0.025)
        nameLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.025)
        secondNameLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.025)
        logOutButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.021)
        addPhotoButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.015)
        savePhotoButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.021)
    }
    
    
    private func labelSettings() {
        imageSavedLabel.alpha = 0
        historyLabel.backgroundColor = .systemGray6
        historyLabel.textAlignment = .center
    }
    
    
    private func tableViewSettings() {
        mainTableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    
    private func showAuthentication() {
        let vc = AuthenticationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    //MARK: - Layout
    private func setConstraints() {
        imageSavedLabel.textColor = .systemGreen
        NSLayoutConstraint.activate([
            historyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
            historyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            historyLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            historyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            mainTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 5),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            profileImage.widthAnchor.constraint(equalToConstant: view.frame.height * 0.12),
            profileImage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.12),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageSavedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSavedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addPhotoButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 0),
            addPhotoButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0),
            addPhotoButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.035),
            addPhotoButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.035),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 7),
            secondNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            savePhotoButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            savePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            logOutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
        ])
    }
}
