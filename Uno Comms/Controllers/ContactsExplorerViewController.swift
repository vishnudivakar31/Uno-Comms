//
//  ContactsExplorerViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/10/21.
//

import UIKit
import MessageUI

class ContactsExplorerViewController: UIViewController {

    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let activityAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    private let contactsExplorerService = ContactsExplorerService()
    private var sharedComms: [SharedComm] = []
    
    public var friendUID: String?
    public var friendName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsExplorerService.delegate = self
        setupTableView()
        if let friendUID = friendUID {
            contactsExplorerService.getAllSharedComms(uid: friendUID)
            self.presentActivityAlert(title: "Contacts", msg: "Please wait while we are fetching the comms..")
        }
        
        if let friendName = friendName {
            contactNameLabel.text = friendName
        }
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SharedCommsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SharedCommsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        tableView.rowHeight = 60.0
    }
    
    private func presentActivityAlert(title: String, msg: String) {
        activityAlert.title = title
        activityAlert.message = msg
        present(activityAlert, animated: true, completion: nil)
    }
    
    private func presentInfo(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func performTableOption(sharedComm: SharedComm) {
        var url: URL?
        var httpURL: URL?
        
        if sharedComm.commType == .EMAIL {
            sendMail(email: sharedComm.identifier)
            return
        } else if sharedComm.commType == .TELEPHONE {
            url = URL(string: "tel://\(sharedComm.identifier)")
        } else if sharedComm.commType == .FACEBOOK {
            url = URL(string: "fb://profile?app_scoped_user_id=\(sharedComm.identifier)")
            httpURL = URL(string: "https://facebook.com/\(sharedComm.identifier)")!
        } else if sharedComm.commType == .INSTAGRAM {
            url = URL(string: "instagram://user?username=\(sharedComm.identifier)")
            httpURL = URL(string: "https://instagram.com/\(sharedComm.identifier)")
        }
        
        if let url = url {
            let application = UIApplication.shared
            if application.canOpenURL(url) {
                application.open(url, options: [:], completionHandler: nil)
            } else {
                application.open(httpURL!, options: [:])
            }
        }
    }
    
    private func sendMail(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true, completion: nil)
        }
    }
    
}

// Extension TableView Delegates
extension ContactsExplorerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedComms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sharedComm = self.sharedComms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedCommsTableViewCell", for: indexPath) as! SharedCommsTableViewCell
        cell.identifierLabelText = sharedComm.identifier
        cell.documentID = sharedComm.id
        cell.commLogoImage = UIImage(named: sharedComm.commType.rawValue)
        cell.shared = sharedComm.shared
        cell.drawCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sharedComm = self.sharedComms[indexPath.row]
        performTableOption(sharedComm: sharedComm)
    }
}

// Extension ContactsExplorerService Delegate
extension ContactsExplorerViewController: ContactsExplorerDelegate {
    func getAllSharedCommsCallback(sharedComms: [SharedComm]?, error: Error?) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Contacts", msg: error.localizedDescription)
            } else if let sharedComms = sharedComms {
                DispatchQueue.main.async {
                    self.sharedComms = sharedComms.filter { $0.shared == true }
                    self.tableView.reloadData()
                }
            } else {
                self.presentInfo(title: "Contacts", msg: "no records found...")
            }
        }
    }
}

// Extenstion MFMAilComposerViewDeleagte
extension ContactsExplorerViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
