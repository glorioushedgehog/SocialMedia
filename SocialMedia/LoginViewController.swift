//
//  LoginViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/16/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func loginAndSaveToken() {
        let username = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        MessageService.sharedMessageService.login(username: username, password: password) { (token) in
            if let tokenId = token {
                DispatchQueue.main.async {
                    UserStorage.shared.saveUserInfo(username: username, token: tokenId)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func goButtonTapped(_ sender: Any) {
        loginAndSaveToken()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField && !(nameTextField.text?.isEmpty ?? false) {
            passwordTextField.resignFirstResponder()
            loginAndSaveToken()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
