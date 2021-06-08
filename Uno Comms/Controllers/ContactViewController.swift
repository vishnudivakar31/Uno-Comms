//
//  ContactViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/8/21.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var accountUsers: [AccountUser] = [
        AccountUser(name: "Vishnu Divakar", uid: "asdasd", profilePictureURL: "https://firebasestorage.googleapis.com/v0/b/uno-comms.appspot.com/o/images%2FVTWnHZBYmcWBzIMIfchcTc14ibV2.png?alt=media&token=0b1b600f-2cbd-4350-82e1-d065365cece2", joinedDate: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        tableView.rowHeight = 60.0
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
}
