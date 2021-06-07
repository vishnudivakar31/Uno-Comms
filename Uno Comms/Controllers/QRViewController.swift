//
//  QRViewController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/6/21.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var buttonView: UIStackView!
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let qrService = QRService()
    private let activityAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrService.qrDelegates = self
        if let uid = qrService.getUID(), let qrCode = generateQRCode(content: uid) {
            qrImage.image = qrCode
            qrImage.layer.magnificationFilter = .nearest
        }
        buttonView.layer.cornerRadius = 10.0
        setupQRScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    @IBAction func onScanTapped(_ sender: Any) {
        previewLayer.isHidden = false
        captureSession.startRunning()
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
    
    private func setupQRScanner() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            presentInfo(title: "Scan QR Code", msg: "Your device does not support QR scanner")
            captureSession = nil
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            presentInfo(title: "Scan QR Code", msg: "Your device does not support QR scanner")
            captureSession = nil
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    private func foundCode(code: String) {
        presentActivityAlert(title: "Contact found", msg: "adding contacts to your account, please wait...")
        qrService.addContact(uid: code)
    }
}

// MARK:- Extenstion AVCaptureMetadataOutputObjectsDelegate
extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            foundCode(code: stringValue)
        }
        previewLayer.isHidden = true
    }
}

// MARK:- Extenstion QRServiceDelegates
extension QRViewController: QRDelegates {
    func addContactCallback(contact: Contact?, error: Error?) {
        activityAlert.dismiss(animated: true) {
            if let error = error {
                self.presentInfo(title: "Save Contact?", msg: error.localizedDescription)
            } else if let _ = contact {
                self.presentInfo(title: "Save Contact?", msg: "Contact added to your account successfully. Navigate to contacts to view them")
            } else {
                self.presentInfo(title: "Save Contact?", msg: "Unable to save. Try again later.")
            }
        }
    }
}
