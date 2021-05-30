//
//  CreateAccountViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 5/30/21.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perpareView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func perpareView() {
        changePlaceholderColor()
        beautifySubmitButton()
        assignKeyboardDelegatesToTextField()
        assignGestureToGoBack()
    }
    
    private func assignGestureToGoBack() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func goBack(gesture: UIGestureRecognizer) {
        performSegue(withIdentifier: "GoToLoginScreen", sender: self)
    }
     
    private func changePlaceholderColor() {
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
    }
    
    private func beautifySubmitButton() {
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 5
    }
    
    private func assignKeyboardDelegatesToTextField() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    @IBAction func onUploadPictureTapped(_ sender: Any) {
    }
    
    @IBAction func onSubmitTapped(_ sender: Any) {
    }
    
    
    
}

// MARK:- Extenstion for TextField Delegate
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
