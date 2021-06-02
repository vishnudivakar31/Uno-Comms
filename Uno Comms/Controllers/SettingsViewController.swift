//
//  SettingsViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    private var userAccount: AccountUser?
    private let settingsService = SettingsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsService.settingsDelegate = self
        beautifyProfilePicture()
        settingsService.getUserAccount()
    }
    
    @IBAction func onUploadPictureTapped(_ sender: Any) {
    }
    
    @IBAction func onChangeNameTapped(_ sender: Any) {
    }
    
    @IBAction func onRequestPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func onDisableAccountTapped(_ sender: Any) {
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
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
}

// MARK:- Extension settings delegate
extension SettingsViewController: SettingsDelegate {
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
