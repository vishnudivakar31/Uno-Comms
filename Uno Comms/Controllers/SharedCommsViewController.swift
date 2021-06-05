//
//  SharedCommsViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/3/21.
//

import UIKit

class SharedCommsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var sharedComms:[SharedComm] = []
    private var facebookPresent: Bool = false
    private var instagramPresent: Bool = false
    private var linkedinPresent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SharedCommsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SharedCommsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        tableView.rowHeight = 60.0
    }
    
    @IBAction func onAddCommsTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Comms Type", message: "Please select comms type. Only one handler per Facebook, Instagram and LinkedIn", preferredStyle: .actionSheet)
        let phonenumberAction = UIAlertAction(title: "Phone Number", style: .default) { _ in
            // TODO:- Phone Number Action
        }
        let emailAction = UIAlertAction(title: "Email", style: .default) { _ in
            // TODO:- Email Action
        }
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { _ in
            // TODO:- Facebook action
        }
        let instagramAction = UIAlertAction(title: "Instagram", style: .default) { _ in
            // TODO:- Instagram action
        }
        let linkedinAction = UIAlertAction(title: "LinkedIn", style: .default) { _ in
            // TODO:- LinkedIn action
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(phonenumberAction)
        alertController.addAction(emailAction)
        alertController.addAction(cancelAction)
        
        if !facebookPresent {
            alertController.addAction(facebookAction)
        }
        
        if !instagramPresent {
            alertController.addAction(instagramAction)
        }
        
        if !linkedinPresent {
            alertController.addAction(linkedinAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// Extension for UITableViewDelegate
extension SharedCommsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sharedComms.count
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
}
