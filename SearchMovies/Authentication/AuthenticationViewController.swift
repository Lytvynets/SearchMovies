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

class AuthenticationViewController: UIViewController {
    
    enum State {
        case registration
        case login
    }
    
    var currentState: State = .registration
    
    lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gill Sans", size: 30)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Registration"
        return label
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
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("SignIn", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(eMailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(okButton)
        view.addSubview(nameTextField)
        view.addSubview(secondNameTextField)
        view.addSubview(registrationLabel)
        
        buttonLayout()
        textFieldsLayout()
        changeState(state: currentState)
    }
    
    
    //MARK: - Layout
    private func textFieldsLayout() {
        NSLayoutConstraint.activate([
            registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            registrationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            nameTextField.bottomAnchor.constraint(equalTo: secondNameTextField.topAnchor, constant: -15),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            nameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            secondNameTextField.bottomAnchor.constraint(equalTo: eMailTextField.topAnchor, constant: -15),
            secondNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            secondNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            eMailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            eMailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            eMailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eMailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.2),
            passwordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            passwordTextField.topAnchor.constraint(equalTo: eMailTextField.bottomAnchor, constant: 15),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    private func buttonLayout() {
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.5),
            signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            okButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 5),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/1.5),
            okButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
        ])
    }
    
    
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
                            ref.child(userResult.user.uid).onDisconnectUpdateChildValues(["name": name ,"email": email])
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
                        
                        print("Dismis")
                    }
                }
            }else{
                showAlert()
                // self.dismiss(animated: true, completion: nil)
                print("Alert")
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
            signInButton.setTitle("Login", for: .normal)
            registrationLabel.text = "Registration"
        case .login:
            nameTextField.isHidden = true
            secondNameTextField.isHidden = true
            registrationLabel.text = "Login"
            signInButton.setTitle("Registration", for: .normal)
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
      //  self.dismiss(animated: true)
        authentication()
        
    }
    
}


extension AuthenticationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // authentication()
        print("textFieldShouldReturn")
        return true
    }
    
}
