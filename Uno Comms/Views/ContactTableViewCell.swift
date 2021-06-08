//
//  ContactTableViewCell.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/8/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    public var profileImageUrl: String?
    public var nameText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = #colorLiteral(red: 0.07602740079, green: 0.1669456363, blue: 0.3494701087, alpha: 1)
        redraw()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func redraw() {
        if let nameText = nameText {
            nameLabel.text = nameText
        }
        if let profileImageUrl = profileImageUrl {
            let url = URL(string: profileImageUrl)!
            self.downloadImage(url: url)
        }
    }
    
    private func downloadImage(url: URL) {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.profileImageView.image = image
        }
    }
    
}
