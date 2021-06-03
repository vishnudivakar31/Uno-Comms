//
//  SharedCommsTableViewCell.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/3/21.
//

import UIKit

protocol SharedCommsDelegate {
    func onSharedCallback(documentID: String?)
    func onDeleteCallback(documentID: String?)
}

class SharedCommsTableViewCell: UITableViewCell {

    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var commLogo: UIImageView!
    @IBOutlet weak var commIdentifier: UILabel!
    
    public var identifierLabelText: String?
    public var commLogoImage: UIImage?
    public var commIdentifierText: String?
    public var documentID: String?
    public var sharedCommsDelegate: SharedCommsDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let identifierLabelText = identifierLabelText {
            identifierLabel.text = identifierLabelText
        }
        
        if let commLogoImage = commLogoImage {
            commLogo.image = commLogoImage
        }
        
        if let commIdentifierText = commIdentifierText {
            commIdentifier.text = commIdentifierText
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onSharedButtonTapped(_ sender: Any) {
        sharedCommsDelegate?.onSharedCallback(documentID: documentID)
    }
    
    @IBAction func onDeleteButtonTapped(_ sender: Any) {
        sharedCommsDelegate?.onDeleteCallback(documentID: documentID)
    }
    
}
