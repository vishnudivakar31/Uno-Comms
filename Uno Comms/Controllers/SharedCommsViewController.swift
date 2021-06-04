//
//  SharedCommsViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/3/21.
//

import UIKit

class SharedCommsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var sharedComms:[SharedComm] = [
        SharedComm(uid: "12123", commType: .EMAIL, identifier: "vishnudivakar31@gmail.com", shared: true),
        SharedComm(uid: "12123", commType: .EMAIL, identifier: "vd276@njit.edu", shared: true),
        SharedComm(uid: "12123", commType: .WHATSAPP, identifier: "551-280-7162", shared: false),
        SharedComm(uid: "12123", commType: .TELEPHONE, identifier: "551-280-7162", shared: true),
        SharedComm(uid: "12123", commType: .TELEPHONE, identifier: "9447319349", shared: true),
        SharedComm(uid: "12123", commType: .FACEBOOK, identifier: "vishnu.divakar.71", shared: true),
        SharedComm(uid: "12123", commType: .INSTAGRAM, identifier: "wanderingthinkter", shared: false),
    ]
    
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
