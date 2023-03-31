//
//  AuthenticationViewController.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class AuthenticationViewController: UIViewController {
    
    enum State {
        case registration
        case login
    }
    
    private var currentState: State = .registration
    
    lazy var registrationLabel = LabelBuilder(fontSize: 30, startText: "Registration", color: .black)
    lazy var haveAccountLabel = LabelBuilder(fontSize: 18, startText: "Already have an account?", color: .black)
    
    
    lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.backgroundColor = #colorLiteral(red: 0.9373161197, green: 0.937415421, blue: 0.9404873252, alpha: 1)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    private lazy var secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Second name"
        textField.backgroundColor = #colorLiteral(red: 0.9373161197, green: 0.937415421, blue: 0.9404873252, alpha: 1)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    
    private lazy var eMailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.backgroundColor = #colorLiteral(red: 0.9373161197, green: 0.937415421, blue: 0.9404873252, alpha: 1)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.backgroundColor = #colorLiteral(red: 0.9373161197, green: 0.937415421, blue: 0.9404873252, alpha: 1)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    
    private lazy var okButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("SignIn", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentMode = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(signInButton)
        view.addSubview(okButton)
        view.addSubview(haveAccountLabel)
        view.addSubview(registrationLabel)
        view.addSubview(textFieldsStackView)
        textFieldsStackView.addArrangedSubview(nameTextField)
        textFieldsStackView.addArrangedSubview(secondNameTextField)
        textFieldsStackView.addArrangedSubview(eMailTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        buttonLayout()
        textFieldsLayout()
        changeState(state: currentState)
        fontSettings()
    }
    
    
    //MARK: - Authentication
    func authentication() {
        let name = nameTextField.text!
        let secondName = secondNameTextField.text!
        let password = passwordTextField.text!
        let email = eMailTextField.text!
        switch currentState {
        case .registration:
            if !name.isEmpty && !password.isEmpty && !email.isEmpty && !secondName.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { userResult, error in
                    if error == nil {
                        if let userResult = userResult {
                            print(userResult.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(userResult.user.uid).setValue(["name": name ,"email": email, "secondName": secondName])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                showAlert()
            }
        case .login:
            if !password.isEmpty && !email.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    print("RESULT: \(String(describing: result?.user.uid))")
                    if error == nil {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                showAlert()
            }
        }
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Помилка", message: "Заповніть поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - State view
    private func changeState(state: State) {
        switch state {
        case .registration:
            nameTextField.isHidden = false
            secondNameTextField.isHidden = false
            signInButton.setTitle("Sign in", for: .normal)
            registrationLabel.text = "Registration"
            haveAccountLabel.text = "Already have an account?"
        case .login:
            haveAccountLabel.text = "Do you want to create an account?"
            nameTextField.isHidden = true
            secondNameTextField.isHidden = true
            registrationLabel.text = "Sign in"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    //MARK: Actions
    @objc func signInButtonAction() {
        if currentState == .registration {
            currentState = .login
        }else {
            currentState = .registration
        }
        changeState(state: currentState)
    }
    
    
    @objc func okButtonAction() {
        authentication()
    }
    
    
    //MARK: - Font settings
    func fontSettings() {
        registrationLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.035)
        haveAccountLabel.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.021)
        signInButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.02)
        okButton.titleLabel?.font = UIFont(name: "Futura Medium", size: view.frame.height * 0.025)
    }
    
    
    //MARK: - Layout
    private func textFieldsLayout() {
        registrationLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65),
            haveAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -21),
            haveAccountLabel.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 10),
            registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            registrationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            nameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
            secondNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            secondNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
            eMailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            eMailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            passwordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
        ])
    }
    
    
    private func buttonLayout() {
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: haveAccountLabel.trailingAnchor, constant: 5),
            signInButton.centerYAnchor.constraint(equalTo: haveAccountLabel.centerYAnchor),
            signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
            okButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
            okButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/18),
        ])
    }
}




//MARK: Work with USER DATA
struct User {
    let name: String
    let secondName: String
}
