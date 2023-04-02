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
    
    lazy var nameLabel = LabelBuilder(fontSize: 20, startText: "Name", color: .black)
    lazy var secondNameLabel = LabelBuilder(fontSize: 20, startText: "Second name", color: .black)
    lazy var imageSavedLabel = LabelBuilder(fontSize: 15, startText: "Image Saved!", color: .black)
    lazy var historyLabel = LabelBuilder(fontSize: 15, startText: "Search history", color: .black)
    
    
    let mainTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        return indicator
    }()
    
    lazy var profileImage: UIImageView = {
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
    
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        return button
    }()
    
    
    lazy var addPhotoButton: UIButton = {
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
    
    
    lazy var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(uploadPhotoButtonAction), for: .touchUpInside)
        return button
    }()
    
    
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
        imageSavedLabel.alpha = 0
        historyLabel.backgroundColor = .systemGray6
        historyLabel.textAlignment = .center
        setConstraints()
        fontSettings()
        tableViewSettings()
        let realm = try! Realm()
        dataManager.historyMoviesArray = realm.objects(History.self)
        self.picker.delegate = self
        self.picker.allowsEditing = true
    }
    
    
    private func tableViewSettings() {
        mainTableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    
    //Adding a profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.profileImage.image = originImage
        guard let image = profileImage.image?.imageAsset?.value(forKey: "assetName") else { return }
        print("NAME: \(image)")
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    
    func addImgData() {
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
            
            guard metadata != nil else {
                print("Error UPLOAD DDDDAAAATTTAAAAA \(String(describing: error))")
                return
            }
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    print("Image url \(String(describing: url))")
                    return
                }
            }
        }
    }
    
    
    //MARK: - Actions
    @objc private func logOutAction() {
        print("Log out")
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTableView.reloadData()
        test()
    }
    
    
    func test() {
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
            self.getImg(name: useImage) { img in
                DispatchQueue.main.async {
                    self.profileImage.image = img
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
            
            print(username)
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    
    func getImg(name: String, completion: @escaping (UIImage) -> Void){
        let storageRef = Storage.storage()
        let reference = storageRef.reference()
        let refPath = reference.child("Images /")
        var image = UIImage(systemName: "person.fill")
        let fileRef = refPath.child(name)
        fileRef.getData(maxSize: 4288*2848) { data, error in
            guard error == nil else {completion(image!); return }
            image = UIImage(data: data!)!
            completion(image!)
        }
    }
    
    
    func fontSettings() {
        imageSavedLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.02)
        historyLabel.font = UIFont(name: "Apple Symbols", size: view.frame.height * 0.025)
        nameLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.025)
        secondNameLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.025)
        logOutButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.021)
        addPhotoButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.015)
        savePhotoButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.021)
    }
    
    
    private func showAuthentication() {
        let vc = AuthenticationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height / 2
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
