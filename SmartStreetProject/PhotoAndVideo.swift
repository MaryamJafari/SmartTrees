//
//  PhotoAndVideo.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/16/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import AssetsLibrary
import MessageUI
import AVFoundation

class PhotoAndVideo: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {
    let imagePickerController = UIImagePickerController()
    
    
    @IBOutlet weak var faceBook: UIButton!
    @IBOutlet weak var Delete: CustomedButton!
    @IBOutlet weak var share: CustomedButton!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var treeImage: UIImageView!
    
    var treeBarcode : String!
    
    
    @IBAction func ShareClick(_ sender: Any) {
        faceBook.isHidden = false
        email.isHidden = false
        message.isHidden = false
    }
    
    @IBAction func shareWithEmail(_ sender: Any) {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.delegate = self
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(treeImage.image!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        let treeName = PardeTreesFromCSVFile().getTreeNameFromBarcode(barcode: treeBarcode)
        mailComposeVC.setSubject("Photo for Tree \(treeName)")
        
        mailComposeVC.setMessageBody("<html><body><p>This is your message</p></body></html>", isHTML: true)
        
        
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareWithFB(_ sender: Any) {
        let screen = UIScreen.main
        if let window = UIApplication.shared.keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet?.setInitialText("Hello, Facebook!")
            composeSheet?.add(image)
            
            present(composeSheet!, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareWithMessage(_ sender: Any) {
        let image = treeImage
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func takepic(_ sender: Any) {
        
    }
    
    @IBOutlet weak var message: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        faceBook.isHidden = true
        email.isHidden = true
        message.isHidden = true
        if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.front) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else {
            noCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            treeImage.image = image
            
        }
        else{
            print("There was a problem getting the image")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func recordButtonPress(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [kUTTypeMovie as String]
            imagePickerController.delegate = self
            imagePickerController.videoMaximumDuration = 10.0
            present(imagePickerController, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }
    }
    
    @IBAction func playButtonPress(sender: AnyObject) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}
