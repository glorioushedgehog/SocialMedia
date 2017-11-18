//
//  LoginViewController.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/16/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// allows the user to enter their username and password
// so that their token ID can be retrieved from the server
class LoginViewController: UIViewController {
    
    // recieves the user's username
    @IBOutlet weak var nameTextField: UITextField!
    
    // recieves the user's password
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prepare to detect the return key on the keyboard
        // being pressed
        nameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // send the login info to the server and save
    // the token ID to UserDefaults if login is
    // successful
    func loginAndSaveToken() {
        let username = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        MessageService.sharedMessageService.login(username: username, password: password) { (token) in
            if let tokenId = token {
                DispatchQueue.main.async {
                    // store the token ID in UserDefaults
                    UserStorage.shared.saveUserInfo(username: username, token: tokenId)
                    // dismiss the login view controller so that the user can
                    // use the rest of the app
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // detect the user pressing the "GO" button
    @IBAction func goButtonTapped(_ sender: Any) {
        loginAndSaveToken()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // switch to editing passwordTextField when the user presses the return key
        // while editing nameTextField
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        }
        // login when the user presses the return key while editing passwordTextField
        if textField == passwordTextField && !(nameTextField.text?.isEmpty ?? false) {
            // close the keyboard while the login is being performed
            passwordTextField.resignFirstResponder()
            loginAndSaveToken()
        }
        return true
    }
    
    // allow the user to stop editing either of the text fields
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
