//
//  QRViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/6/21.
//

import UIKit

class QRViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var buttonView: UIStackView!
    
    private let qrService = QRService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = qrService.getUID(), let qrCode = generateQRCode(content: uid) {
            qrImage.image = qrCode
            qrImage.layer.magnificationFilter = .nearest
        }
        
        buttonView.layer.cornerRadius = 10.0
    }
    
    @IBAction func onScanTapped(_ sender: Any) {
    }
    
    private func generateQRCode(content: String) -> UIImage? {
        let data = content.data(using: .ascii, allowLossyConversion: false)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
