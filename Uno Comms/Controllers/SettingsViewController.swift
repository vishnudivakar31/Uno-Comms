//
//  SettingsViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import UIKit
import Firebase
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    private var userAccount: AccountUser?
    private let settingsService = SettingsService()
    private let imagePicker = UIImagePickerController()
    private let activityAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var credential: Credential?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsService.settingsDelegate = self
        beautifyProfilePicture()
        settingsService.getUserAccount()
        imagePicker.delegate = self
        
        do {
            let results: [Credential] = try context.fetch(Credential.fetchRequest())
            if results.count > 0 {
                credential = results.first
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func onUploadPictureTapped(_ sender: Any) {
        getPicture()
    }
    
    @IBAction func onChangeNameTapped(_ sender: Any) {
    }
    
    @IBAction func onRequestPasswordTapped(_ sender: Any) {
        presentActivityAlert(title: "Please wait", msg: "requesting password reset....")
        settingsService.sendPasswordReset()
    }
    
    @IBAction func onDisableAccountTapped(_ sender: Any) {
        presentActivityAlert(title: "Please wait", msg: "deleting account...")
        settingsService.disableAccount()
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        presentActivityAlert(title: "Please wait", msg: "logging out....")
        settingsService.logout()
    }
    
    private func beautifyProfilePicture() {
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.borderWidth = 3.0
        profilePicture.layer.borderColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
    }
    
    private func presentInfo(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
    
    private func presentActivityAlert(title: String, msg: String) {
        activityAlert.title = title
        activityAlert.message = msg
        present(activityAlert, animated: true, completion: nil)
    }
}

// MARK:- Extension settings delegate
extension SettingsViewController: SettingsDelegate {
    func logoutCallback(status: Bool, msg: String) {
        activityAlert.dismiss(animated: true) {
            if status {
                if let credential = self.credential {
                    self.context.delete(credential)
                }
                self.performSegue(withIdentifier: "PerformLogout", sender: self)
            } else {
                self.presentInfo(title: "Logout", message: msg)
            }
        }
    }
    
    func deleteAccountCallback(status: Bool, msg: String) {
        activityAlert.dismiss(animated: true) {
            if status {
                if let credential = self.credential {
                    self.context.delete(credential)
                }
                self.performSegue(withIdentifier: "PerformLogout", sender: self)
            } else {
                self.presentInfo(title: "Account Deletion", message: msg)
            }
        }
    }
    
    func sendPasswordReset(status: Bool, msg: String) {
        activityAlert.dismiss(animated: true) {
            self.presentInfo(title: "Password Reset Request", message: msg)
        }
    }
    
    func updateProfilePicture(user: AccountUser?, status: Bool, msg: String) {
        activityAlert.dismiss(animated: true) {
            if status {
                self.userAccount = user!
                self.presentInfo(title: "Update Profile Picture", message: "Successfully updated")
            } else {
                self.presentInfo(title: "Warning", message: msg)
            }
        }
    }
    
    func getUserAccountCallback(user: AccountUser?, error: Error?) {
        if let error = error {
            self.presentInfo(title: "Warning", message: error.localizedDescription)
        } else if let user = user {
            self.userAccount = user
            let profileUrl: URL? = URL(string: user.profilePictureURL)
            DispatchQueue.main.async {
                self.nameLabel.text = user.name
                if let url = profileUrl {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data)  {
                            self.profilePicture.image = image
                        } else {
                            print("uable to create image from url")
                        }
                    } else {
                        print("unable to fetch contents from url")
                    }
                } else {
                    print("unable to form url")
                }
            }
        } else {
            self.presentInfo(title: "Warning", message: "no valid user account found. try again later.")
        }
    }
}

// MARK:- Extension for ImagePicker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected an image, but was provided with \(info)")
        }
        profilePicture.image = image
        picker.dismiss(animated: true) {
            if let userAccount = self.userAccount, let imageData = image.pngData() {
                self.presentActivityAlert(title: "Please wait", msg: "uploading your profile picture. please wait")
                self.settingsService.updateProfilePicture(userAccount: userAccount, data: imageData)
            }
        }
    }
}
