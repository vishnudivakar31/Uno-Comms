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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoStavView: UIStackView!
    @IBOutlet weak var selectionView: UIView!
    
    public var identifierLabelText: String?
    public var commLogoImage: UIImage?
    public var documentID: String?
    public var shared: Bool?
    public var sharedCommsDelegate: SharedCommsDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoStavView.layer.cornerRadius = infoStavView.bounds.height / 2
        drawCell()
    }
    
    public func drawCell() {
        if let identifierLabelText = identifierLabelText {
            identifierLabel.text = identifierLabelText
        }
        
        if let commLogoImage = commLogoImage {
            commLogo.image = commLogoImage
        }
        
        if let shared = shared {
            statusLabel.text = shared ? "Shared" : "Not Shared"
            if shared {
                infoStavView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                infoStavView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectionView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        } else {
            selectionView.backgroundColor = #colorLiteral(red: 0.8680856228, green: 0.9031531811, blue: 0.9152787924, alpha: 1)
        }
    }
}
