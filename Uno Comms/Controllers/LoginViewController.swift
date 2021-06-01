//
//  LoginViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/30/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let activityAlertController = UIAlertController(title: "In Progress", message: "", preferredStyle: .actionSheet)
    private let loginService = LoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        loginService.loginDelegate = self
    }

    @IBAction func onLoginButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        loginWith(email, password)
    }
    
    @IBAction func onForgorPasswordTapped(_ sender: Any) {
        resetPassword()
    }
    
    private func presentInfo(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func prepareView() {
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = #colorLiteral(red: 0.07602740079, green: 0.1669456363, blue: 0.3494701087, alpha: 1)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    private func resetPassword() {
        let alertController = UIAlertController(title: "Enter your email", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            let textField = alertController.textFields?.first
            let email = textField?.text ?? ""
            self.loginService.resetPassword(email: email)
            self.dismiss(animated: true) {
                self.activityAlertController.message = "sending password reset email...."
                self.present(self.activityAlertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func loginWith(_ email: String, _ password: String) {
        if (email == "" || password == "") {
            presentInfo(title: "Warning", msg: "All fields are mandatory")
        } else {
            activityAlertController.message = "attempt to login. please wait..."
            present(activityAlertController, animated: true, completion: nil)
            loginService.loginWith(email: email, password: password)
        }
    }
    
}

// Extension for LoginDelegates
extension LoginViewController: LoginDelegate {
    func loginAttemptCallback(status: Bool, msg: String) {
        activityAlertController.dismiss(animated: true) {
            if status {
                // TODO:- Perform Segue to move to home screen
            } else {
                self.presentInfo(title: "Warning", msg: msg)
            }
        }
    }
    
    func resetPasswordCallback(status: Bool, msg: String) {
        activityAlertController.dismiss(animated: true) {
            var title = "Info"
            if !status {
                title = "Warning"
            }
            self.presentInfo(title: title, msg: msg)
        }
    }
}

// MARK:- Extension for TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
