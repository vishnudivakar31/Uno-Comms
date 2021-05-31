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
    
    private let imagePicker = UIImagePickerController()
    private let authenticationService = AuthenticationService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perpareView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        imagePicker.delegate = self
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
    
    @IBAction func onUploadPictureTapped(_ sender: Any) {
        getPicture()
    }
    
    @IBAction func onSubmitTapped(_ sender: Any) {
    }
    
    private func perpareView() {
        changePlaceholderColor()
        beautifySubmitButton()
        beautifyProfilePicture()
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
    
    private func beautifyProfilePicture() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = #colorLiteral(red: 0.07602740079, green: 0.1669456363, blue: 0.3494701087, alpha: 1)
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
    
    private func getPicture() {
        let alertController = UIAlertController(title: "Select Media", message: "You can select a photo from your photos or you can snap a photo now.", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.pickImage(source: "camera")
        }
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { alertAction in
            self.pickImage(source: "photos")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func pickImage(source: String) {
        imagePicker.allowsEditing = true
        if source == "camera" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// MARK:- Extension for TextField Delegate
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- Extension for ImagePicker
extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected an image, but was provided with \(info)")
        }
        profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
