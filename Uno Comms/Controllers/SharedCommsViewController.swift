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
    private var whatsappPresent: Bool = false
    
    private let sharedCommsService = SharedCommsService()
    private let activityAlert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedCommsService.commsDelegate = self
        let nib = UINib(nibName: "SharedCommsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SharedCommsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        tableView.rowHeight = 60.0
        
        presentActivityAlert(title: "Please wait", msg: "fetching your shared comms...")
        sharedCommsService.getAllSharedComms()
    }
    
    @IBAction func onAddCommsTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Comms Type", message: "Please select comms type. Only one handler per Facebook, Instagram and LinkedIn", preferredStyle: .actionSheet)
        let phonenumberAction = UIAlertAction(title: "Phone Number", style: .default) { _ in
            self.getIdentifier(commType: COMMS_TYPE.TELEPHONE)
        }
        let emailAction = UIAlertAction(title: "Email", style: .default) { _ in
            self.getIdentifier(commType: COMMS_TYPE.EMAIL)
        }
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { _ in
            self.getIdentifier(commType: COMMS_TYPE.FACEBOOK)
        }
        let instagramAction = UIAlertAction(title: "Instagram", style: .default) { _ in
            self.getIdentifier(commType: COMMS_TYPE.INSTAGRAM)
        }
        let linkedinAction = UIAlertAction(title: "LinkedIn", style: .default) { _ in
            self.getIdentifier(commType: COMMS_TYPE.LINKEDIN)
        }
        let whatsappAction = UIAlertAction(title: "WhatsApp", style: .default) { _ in
            self.getIdentifier(commType: .WHATSAPP)
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
        
        if !whatsappPresent {
            alertController.addAction(whatsappAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func getIdentifier(commType: COMMS_TYPE) {
        let alertController = UIAlertController(title: "Enter the identifier", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "handler"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let textField = alertController.textFields!.first
            if let uid = self.sharedCommsService.getUserID() {
                let sharedComm = SharedComm(uid: uid, commType: commType, identifier: textField?.text ?? "", shared: true)
                self.presentActivityAlert(title: "Save Shared Comms", msg: "saving shared comms to cloud. please wait..")
                self.sharedCommsService.saveSharedComm(sharedComm: sharedComm)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
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
    
    private func checkCommTypeForPresence(sharedComm: SharedComm) {
        if sharedComm.commType == .FACEBOOK {
            self.facebookPresent = self.facebookPresent || true
        } else if sharedComm.commType == .INSTAGRAM {
            self.instagramPresent = self.instagramPresent || true
        } else if sharedComm.commType == .LINKEDIN {
            self.linkedinPresent = self.linkedinPresent || true
        } else if sharedComm.commType == .WHATSAPP {
            self.whatsappPresent = self.whatsappPresent || true
        }
    }
    
    private func unCheckCommTypeForPresence(sharedComm: SharedComm) {
        if sharedComm.commType == .FACEBOOK {
            self.facebookPresent = false
        } else if sharedComm.commType == .INSTAGRAM {
            self.instagramPresent = false
        } else if sharedComm.commType == .LINKEDIN {
            self.linkedinPresent = false
        } else if sharedComm.commType == .WHATSAPP {
            self.whatsappPresent = false
        }
    }
    
    private func performTableOption(sharedComm: SharedComm, indexPath: IndexPath, option: String) {
        if option == "share" {
            let updatedSharedComm = SharedComm(id: sharedComm.id, uid: sharedComm.uid, commType: sharedComm.commType, identifier: sharedComm.identifier, shared: !sharedComm.shared)
            sharedCommsService.updateSharedComm(sharedComm: updatedSharedComm, indexPath: indexPath)
        } else {
            sharedCommsService.deleteSharedComms(sharedComm: sharedComm, indexPath: indexPath)
        }
    }
    
    private func presentTableOptions(sharedComm: SharedComm, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Options", message: "Are you sure?", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: sharedComm.shared ? "Unshare" : "Share", style: .default) { _ in
            self.presentActivityAlert(title: "Please wait", msg: "Updating your shared comm...")
            self.performTableOption(sharedComm: sharedComm, indexPath: indexPath, option: "share")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.presentActivityAlert(title: "Please wait", msg: "Deleting your shared comm...")
            self.performTableOption(sharedComm: sharedComm, indexPath: indexPath, option: "delete")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sharedComm = sharedComms[indexPath.row]
        presentTableOptions(sharedComm: sharedComm, indexPath: indexPath)
    }
}

// Extension for CommsDelegate
extension SharedCommsViewController: CommsDelegate {
    func deleteSharedCommCallback(shareComm: SharedComm?, error: Error?, indexPath: IndexPath) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Delete shared comm", msg: error.localizedDescription)
            } else if let shareComm = shareComm {
                DispatchQueue.main.async {
                    self.unCheckCommTypeForPresence(sharedComm: shareComm)
                    self.sharedComms.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            } else {
                self.presentInfo(title: "Delete shared comm", msg: "No shared comm")
            }
        }
    }
    
    func updateSharedCommCallback(shareComm: SharedComm?, error: Error?, indexPath: IndexPath) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Share or UnShare", msg: error.localizedDescription)
            } else if let shareComm = shareComm {
                DispatchQueue.main.async {
                    self.sharedComms[indexPath.row] = shareComm
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                self.presentInfo(title: "Share or UnShare", msg: "No shared comm")
            }
        }
    }
    
    func getAllSharedCommsCallback(shareComms: [SharedComm]?, error: Error?) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Getting saved shared comms", msg: error.localizedDescription)
            } else if let shareComms = shareComms {
                DispatchQueue.main.async {
                    self.sharedComms = shareComms
                    for sharedComm in self.sharedComms {
                        self.checkCommTypeForPresence(sharedComm: sharedComm)
                    }
                    self.tableView.reloadData()
                }
            } else {
                self.presentInfo(title: "Saved shared comms", msg: "not available")
            }
        }
    }
    
    func saveSharedCommCallback(sharedComm: SharedComm?, error: Error?) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Save shared comm", msg: error.localizedDescription)
            } else if let _ = sharedComm {
                DispatchQueue.main.async {
                    self.sharedCommsService.getAllSharedComms()
                }
            } else {
                self.presentInfo(title: "Save shared comm", msg: "shared comm not available.")
            }
        }
    }
}
