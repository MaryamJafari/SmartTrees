//
//  ScannerViewController.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/17/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import AVFoundation
import UIKit


class CameraView: UIView {
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

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var cameraView: CameraView!
    let session = AVCaptureSession()
    var barcode : String!
    var isUserbarcode : String!
    var barcodeUser : String!
    var qrCodeFrameView:UIView?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var messageLabel: UILabel!
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    override func loadView() {
        cameraView = CameraView()
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
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        session.commitConfiguration()
        cameraView.layer.session = session
        cameraView.layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
  
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
            if metadataObj.stringValue != nil {
                barcode  = metadataObj.stringValue
            }
            performSegue(withIdentifier: "ReturnBarcodeFromScanner", sender: barcode)
            self.session.stopRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReturnBarcodeFromScanner"{
            if let destination = segue.destination as? Nearby{
                if let barcode = sender as? String{
                    destination.treeBarcode = barcode
                    destination.isShow = true
                }
            }
        }
        
        
    }
    
}
