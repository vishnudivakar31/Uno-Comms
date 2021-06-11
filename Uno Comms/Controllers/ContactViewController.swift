//
//  ContactViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/8/21.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let contactService = ContactService()
    private var accountUsers: [AccountUser] = []
    private let activityAlert = UIAlertController()
    
    private var selectedUser: AccountUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        contactService.contactDelegates = self
        contactService.getContact()
        presentActivityAlert(title: "Please wait", msg: "get your contacts...")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToContactExplorer" {
            guard let contactsExplorerView = segue.destination as? ContactsExplorerViewController else { return }
            if let selectedUser = selectedUser {
                contactsExplorerView.friendUID = selectedUser.uid
                contactsExplorerView.friendName = selectedUser.name
            }
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        tableView.rowHeight = 60.0
    }
    
    private func presentInfo(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentActivityAlert(title: String, msg: String) {
        activityAlert.title = title
        activityAlert.message = msg
        present(activityAlert, animated: true, completion: nil)
    }
}

// Mark:- Extension UITableViewDataSource, UITableViewDelegate
extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accountUser = accountUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        cell.nameText = accountUser.name
        cell.profileImageUrl = accountUser.profilePictureURL
        cell.redraw()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.accountUsers[indexPath.row]
        self.performSegue(withIdentifier: "GoToContactExplorer", sender: self)
    }
}

// MARK:- Extension ContactDelegates
extension ContactViewController: ContactDelegates {
    func registerForContactsCallback(status: Bool, error: Error?) {
        if status {
            contactService.getContact()
        }
    }
    
    func getProfileCallback(userAccounts: [AccountUser]?, error: Error?) {
        DispatchQueue.main.async {
            self.activityAlert.dismiss(animated: true) {
                if let error = error {
                    self.presentInfo(title: "Contacts", msg: error.localizedDescription)
                } else if let userAccounts = userAccounts {
                    DispatchQueue.main.async {
                        self.accountUsers = userAccounts
                        self.tableView.reloadData()
                    }
                } else {
                    self.presentInfo(title: "Contacts", msg: "No records found")
                }
            }
        }
    }
    
    func getContactCallback(contact: Contact?, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.activityAlert.dismiss(animated: true) {
                    self.presentInfo(title: "Contacts", msg: error.localizedDescription)
                }
            } else if let contact = contact {
                self.contactService.getProfiles(uids: contact.friends)
            } else {
                self.activityAlert.dismiss(animated: true) {
                    self.presentInfo(title: "Contacts", msg: "No records found")
                }
            }
        }
    }
}
