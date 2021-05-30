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
        changePlaceholderColor()
        beautifySubmitButton()
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
    
    @IBAction func onUploadPictureTapped(_ sender: Any) {
    }
    
    @IBAction func onSubmitTapped(_ sender: Any) {
    }
    
}
