//
//  ScannerViewController.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/17/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import AVFoundation
import UIKit
import Foundation


class CameraViewForUse: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}
class UserScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var cameraView: CameraViewForUse!
    let session = AVCaptureSession()
    var barcode : String!
    var isUserbarcode : String!
    var barcodeUser : String!
    var qrCodeFrameView:UIView?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var email : String!
    var name : String!
    var phone : String!
    
    @IBOutlet weak var messageLabel: UILabel!
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    override func loadView() {
        cameraView = CameraViewForUse()
        view = cameraView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        session.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if (videoDevice != nil) {
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
            if (videoDeviceInput != nil) {
                if (session.canAddInput(videoDeviceInput!)) {
                    session.addInput(videoDeviceInput!)
                }
            }
            let metadataOutput = AVCaptureMetadataOutput()
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = [
                    AVMetadataObject.ObjectType.ean13,
                    AVMetadataObject.ObjectType.qr
                ]
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
        
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        session.commitConfiguration()
        cameraView.layer.session = session
        cameraView.layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // Set initial camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
        case .landscapeRight:
            videoOrientation = .landscapeRight
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection?.videoOrientation = videoOrientation
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start AV capture session
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop AV capture session
        sessionQueue.async {
            self.session.stopRunning()
        }
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Update camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            videoOrientation = .portrait
        }
        cameraView.layer.connection?.videoOrientation = videoOrientation
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            
            
            if metadataObj.stringValue != nil {
                // Move the message label and top bar to the front
                
                
                print (metadataObj.stringValue)
                print(isUserbarcode)
         
                
                let fullBarcode = metadataObj.stringValue!
                
          
                var fullBarcodeArr = fullBarcode.components(separatedBy: " ")
              email = fullBarcodeArr[0]
                name = fullBarcodeArr.count > 1 ? fullBarcodeArr[1] : nil
             phone = fullBarcodeArr.count > 2 ? fullBarcodeArr[2] : nil
                   // barcodeUser = metadataObj.stringValue
                
                
                
            }
            performSegue(withIdentifier: "LoginWithBarcode", sender:
            self)
            self.session.stopRunning()

        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     
        if segue.identifier == "LoginWithBarcode"{
            if let destination = segue.destination as? SignIn{
               
                    destination.emailA = email
                    destination.name = name
                    destination.phone = phone
                 
                    
                
            }
        }
        
    }
    
}

